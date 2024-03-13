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
        messages = chatMessages.map {
            ChatMessage(role: $0.isSenderUser ? "user" : "assistant", content: $0.textMessage ?? "")
        }
        
        displayAllLoadedMessages(messages: messages)
    }
    
    private func generateText() {
        if chatParameters.chatType == .persona {
            let startPrompt = ChatMessage(role: "assistant", content: chatParameters.startPrompt ?? "")
            TextGenerationNetworkManager.shared.completeMessageAsPersona(messages: messages, personaPrompt: startPrompt){ [weak self] result in
                switch result {
                case .success(let chatMessage):
                    let message = ChatMessage(role: "assistant", content: chatMessage.choices[0].message.content)
                    self?.messages.append(message)
                    print("ChatGPT: \(message.content)")
                    self?.displayMessage(message: message, imageMessage: nil)
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            TextGenerationNetworkManager.shared.completeMessage(messages: messages) { [weak self] result in
                switch result {
                case .success(let chatMessage):
                    let message = ChatMessage(role: "assistant", content: chatMessage.choices[0].message.content)
                    self?.messages.append(message)
                    print("ChatGPT: \(message.content)")
                    self?.displayMessage(message: message, imageMessage: nil)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    private func generateImage() {
        // TODO: Generate Image
        print("generating image...")
    }
    
    private func displayMessage(message: ChatMessage, imageMessage: UIImage?) {
        let presentation = createChatCellPresentation(message: message, imageMessage: imageMessage)
        var isSenderUser: Bool
        
        if message.role == "assistant" {
            isSenderUser = false
        } else if message.role == "user" {
            isSenderUser = true
        } else {
            isSenderUser = false
        }
        
        ChatSaveManager.shared.saveMessage(chatId: chatParameters.chatId, textMessage: message.content, imageMessage: nil, isSenderUser: isSenderUser)
        
        view?.displayMessage(message: presentation)
    }
    
    private func displayAllLoadedMessages(messages: [ChatMessage]) {
        var presentations = [ChatCellPresentation]()
        for message in messages {
            presentations.append(createChatCellPresentation(message: message, imageMessage: nil))
        }
        view?.displayMessages(with: presentations)
    }
    
    private func createChatCellPresentation(message: ChatMessage, imageMessage: UIImage?) -> ChatCellPresentation {
        let senderName: String
        let senderType: SenderType
        let senderImage: String
        
        if message.role == "assistant" {
            if chatParameters.chatType == .persona {
                senderName = chatParameters.aiName
                senderType = .persona
            }else {
                senderName = "chatGPT"
                senderType = .chatGPT
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
                                                imageMessage: nil)
    }
    
    private func displayGreetingMessage() {
        guard let greeting = chatParameters.greetingMessage else { return }
        let greetingMessage = ChatMessage(role: "assistant", content: greeting)
        messages.append(greetingMessage)
        displayMessage(message: greetingMessage, imageMessage: nil)
    }
    
    private func generateChatTitle() {
        TextGenerationNetworkManager.shared.generateChatTitle(chatId: chatParameters.chatId, messages: messages) { [weak self] result in
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
}
