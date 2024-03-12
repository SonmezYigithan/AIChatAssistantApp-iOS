//
//  ChatViewModel.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 10.03.2024.
//

import Foundation
import UIKit

struct ChatParameters {
    let chatType: ChatType
    let aiName: String
    let aiImage: UIImage?
    let startPrompt: String?
}

protocol ChatViewModelProtocol {
    var view: ChatViewProtocol? { get set }
    
    func sendMessage(message: String)
    func viewDidLoad()
}

final class ChatViewModel {
    weak var view: ChatViewProtocol?
    private var messages = [ChatMessage]()
    private let chatParameters: ChatParameters
    
    init(view: ChatViewProtocol, chatParameters: ChatParameters) {
        self.view = view
        self.chatParameters = chatParameters
    }
}

extension ChatViewModel: ChatViewModelProtocol {
    func sendMessage(message: String) {
        let userMessage = ChatMessage(role: "user", content: message)
        messages.append(userMessage)
        
        displayMessage(message: userMessage, senderImage: nil, imageMessage: nil)
        
        if chatParameters.chatType == .imageGeneration {
            generateImage()
        }else {
            generateText()
        }
    }
    
    func viewDidLoad() {
        if chatParameters.chatType == .persona {
            guard let startPrompt = chatParameters.startPrompt else { return }
            let personaPrompt = ChatMessage(role: "assistant", content: startPrompt)
            messages.append(personaPrompt)
        }else if chatParameters.chatType == .imageGeneration {
            let greetingMessage = ChatMessage(role: "assistant", content: "What would you like me to draw")
            messages.append(greetingMessage)
            displayMessage(message: greetingMessage, senderImage: nil, imageMessage: nil)
        }else {
            let greetingMessage = ChatMessage(role: "assistant", content: "Hi! how can I help you?")
            messages.append(greetingMessage)
            displayMessage(message: greetingMessage, senderImage: nil, imageMessage: nil)
        }
    }
    
    private func generateText() {
        TextGenerationNetworkManager.shared.completeMessage(messages: messages) { [weak self] result in
            switch result {
            case .success(let chatMessage):
                let message = ChatMessage(role: "assistant", content: chatMessage.choices[0].message.content)
                self?.messages.append(message)
                print("ChatGPT: \(message.content)")
                self?.displayMessage(message: message, senderImage: nil, imageMessage: nil)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func generateImage() {
        // TODO: Generate Image
        print("generating image...")
    }
    
    private func displayMessage(message: ChatMessage, senderImage: UIImage?, imageMessage: UIImage?) {
        let senderName: String
        let senderType: SenderType
        if message.role == "assistant" {
            if chatParameters.chatType == .persona {
                senderName = chatParameters.aiName
                senderType = .persona
            }else {
                senderName = "chatGPT"
                senderType = .chatGPT
            }
        } else if message.role == "user" {
            senderName = "You"
            senderType = .user
        } else {
            // Unhandled: system
            senderName = "System"
            senderType = .chatGPT
        }
        
        let presentation = ChatCellPresentation(senderType: senderType,
                                                senderName: senderName,
                                                message: message.content,
                                                imageMessage: nil)
        
        view?.displayMessage(message: presentation)
    }
}
