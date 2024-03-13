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
    let aiImage: UIImage?
    let startPrompt: String?
    let isStarred: Bool
    let createdAt: Date
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
            displayGreetingMessage(message: "What would you like me to draw")
        }else {
            displayGreetingMessage(message: "Hi! how can I help you?")
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
            // Unhandled: system (I don't use it but it may return from OpenAI API)
            senderName = "System"
            senderType = .chatGPT
        }
        
        let presentation = ChatCellPresentation(senderType: senderType,
                                                senderName: senderName,
                                                message: message.content,
                                                imageMessage: nil)
        
        view?.displayMessage(message: presentation)
    }
    
    private func displayGreetingMessage(message: String) {
        let greetingMessage = ChatMessage(role: "assistant", content: message)
        messages.append(greetingMessage)
        displayMessage(message: greetingMessage, senderImage: nil, imageMessage: nil)
    }

}
