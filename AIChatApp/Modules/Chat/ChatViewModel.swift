//
//  ChatViewModel.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 10.03.2024.
//

import Foundation
import UIKit

enum ChatType: Int {
    case textGeneration = 1
    case imageGeneration = 2
    case persona = 3
}

struct ChatParameters {
    let chatType: ChatType
    let aiName: String
    let aiImage: String?
    let startPrompt: String?
    let isStarred: Bool
    let createdAt: Date
    let chatId: String
    let greetingMessage: String?
    var chatTitle: String?
}

protocol ChatViewModelProtocol {
    var view: ChatViewProtocol? { get set }
    
    func sendMessage(message: String)
    func viewDidLoad()
    func loadChatMessages(chatMessages: [ChatMessageEntity])
}

final class ChatViewModel {
    weak var view: ChatViewProtocol?
    private var messages = [ChatMessage]()
    private var chatParameters: ChatParameters
    
    /// represents if a new chat view created or a previous one loaded
    var isViewLoaded = false
    var canGenerateChatTitle = true
    
    init(view: ChatViewProtocol, chatParameters: ChatParameters) {
        self.view = view
        self.chatParameters = chatParameters
    }
}

extension ChatViewModel: ChatViewModelProtocol {
    func sendMessage(message: String) {
        let userMessage = ChatMessage(role: "user", content: message)
        messages.append(userMessage)
        
        if canGenerateChatTitle {
            generateChatTitle()
        }
        
        displayMessage(message: userMessage, imageMessage: nil)
        
        if chatParameters.chatType == .imageGeneration {
            generateImage()
        }else {
            generateText()
        }
    }
    
    func viewDidLoad() {
        if isViewLoaded {
            return
        }
        
        displayGreetingMessage()
    }
    
    func loadChatMessages(chatMessages: [ChatMessageEntity]) {
        isViewLoaded = true
        displayAllLoadedMessages(chatMessages: chatMessages)
    }
    
    private func generateText() {
        if chatParameters.chatType == .persona {
            let startPrompt = ChatMessage(role: "assistant", content: chatParameters.startPrompt ?? "")
            TextGenerationManager.shared.completeMessageAsPersona(messages: messages, personaPrompt: startPrompt){ [weak self] result in
                switch result {
                case .success(let chatMessage):
                    let message = ChatMessage(role: "assistant", content: chatMessage.choices[0].message.content)
                    self?.messages.append(message)
                    print("ChatGPT: \(message.content)")
                    self?.displayMessage(message: message, imageMessage: nil)
                    self?.saveMessage(message: message, imageMessage: nil)
                case .failure(let error):
                    print(error)
                    self?.sendNetworkErrorMessage()
                }
            }
        } else {
            TextGenerationManager.shared.completeMessage(messages: messages) { [weak self] result in
                switch result {
                case .success(let chatMessage):
                    let message = ChatMessage(role: "assistant", content: chatMessage.choices[0].message.content)
                    self?.messages.append(message)
                    print("ChatGPT: \(message.content)")
                    self?.displayMessage(message: message, imageMessage: nil)
                    self?.saveMessage(message: message, imageMessage: nil)
                case .failure(let error):
                    print(error)
                    self?.sendNetworkErrorMessage()
                }
            }
        }
    }
    
    private func generateImage() {
        if let message = messages.last {
            // display empty image chat message with loading circle
            let chatMessage = ChatMessage(role: "assistant", content: "Creating image with prompt: \(message.content)")
            displayMessage(message: chatMessage, imageMessage: [""])
            view?.disableSendButton()
            ImageGenerationManager.shared.generateImageFromMessage(message: message) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let response):
                    guard let imageData = response.data?[0].url else {
                        self.view?.enableSendButton()
                        self.sendNetworkErrorMessage()
                        return
                    }
                    print("Created Image URL: \(imageData)")
                    let responseData: [String] = [imageData]
                    
                    // Update Chat Message
                    let presentation = self.createChatCellPresentation(message: chatMessage, imageMessage: responseData)
                    self.view?.updateCell(at: messages.count, presentation: presentation)
                    self.saveMessage(message: message, imageMessage: responseData)
                    self.view?.enableSendButton()
                case .failure(let error):
                    print(error)
                    self.sendNetworkErrorMessage()
                    self.view?.enableSendButton()
                }
            }
        }
    }
    
    private func displayMessage(message: ChatMessage, imageMessage: [String]?) {
        let presentation = createChatCellPresentation(message: message, imageMessage: imageMessage)
        view?.displayMessage(message: presentation)
    }
    
    private func saveMessage(message: ChatMessage, imageMessage: [String]?) {
        var isSenderUser: Bool
        if message.role == "assistant" {
            isSenderUser = false
        } else if message.role == "user" {
            isSenderUser = true
        } else {
            isSenderUser = false
        }
        
        ChatSaveManager.shared.saveMessage(chatId: chatParameters.chatId, textMessage: message.content, imageMessage: imageMessage, isSenderUser: isSenderUser)
    }
    
    private func displayAllLoadedMessages(chatMessages: [ChatMessageEntity]) {
        var presentations = [ChatCellPresentation]()
        for messageEntity in chatMessages {
            let chatMessage = ChatMessage(role: messageEntity.isSenderUser ? "user" : "assistant", content: messageEntity.textMessage ?? "")
            
            // TODO: Later implement multiple image generation.
            // for now I'm just gonna pass first imageMessage as string array
            var imageMessages: [String] = .init()
            if let imageMessage = messageEntity.imageMessage {
                imageMessages = [imageMessage]
            }
            
            presentations.append(createChatCellPresentation(message: chatMessage, imageMessage: imageMessages))
        }
        view?.displayMessages(with: presentations)
    }
    
    private func createChatCellPresentation(message: ChatMessage, imageMessage: [String]?) -> ChatCellPresentation {
        let senderName: String
        let senderType: SenderType
        let senderImage: String
        
        if message.role == "assistant" {
            if chatParameters.chatType == .persona {
                senderName = chatParameters.aiName
                senderType = .persona
            }else if chatParameters.chatType == .textGeneration {
                senderName = chatParameters.aiName
                senderType = .chatGPT
            }else {
                senderName = chatParameters.aiName
                senderType = .imageGenerator
            }
            senderImage = chatParameters.aiImage ?? ""
        } else if message.role == "user" {
            senderName = "You"
            senderType = .user
            senderImage = "person.crop.circle.fill"
        } else {
            // Unhandled: system (I don't use it but it may return from OpenAI API)
            senderName = "System"
            senderType = .chatGPT
            senderImage = chatParameters.aiImage ?? ""
        }
        
        return ChatCellPresentation(senderType: senderType,
                                                senderName: senderName,
                                                senderImage: senderImage,
                                                message: message.content,
                                                imageMessage: imageMessage)
    }
    
    private func displayGreetingMessage() {
        guard let greeting = chatParameters.greetingMessage else { return }
        let greetingMessage = ChatMessage(role: "assistant", content: greeting)
        messages.append(greetingMessage)
        displayMessage(message: greetingMessage, imageMessage: nil)
        saveMessage(message: greetingMessage, imageMessage: nil)
    }
    
    private func generateChatTitle() {
        TextGenerationManager.shared.generateChatTitle(chatId: chatParameters.chatId, messages: messages) { [weak self] result in
            switch result {
            case .success(let response):
                var chatTitle = response.choices[0].message.content
                chatTitle = String(chatTitle.dropFirst().dropLast())
                if var chatParameters = self?.chatParameters {
                    chatParameters.chatTitle = chatTitle
                    ChatSaveManager.shared.saveChatTitle(chatId: chatParameters.chatId, chatTitle: chatTitle)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        canGenerateChatTitle = false
    }
    
    private func sendNetworkErrorMessage() {
        displayMessage(message: ChatMessage(role: "assistant", content: "Network Error"), imageMessage: nil)
    }
}
