//
//  ChatViewModel.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 10.03.2024.
//

import Foundation
import UIKit

protocol ChatViewModelProtocol {
    var view: ChatViewProtocol? { get set }
    
    func sendMessage(message: String)
    func viewDidLoad()
}

final class ChatViewModel {
    weak var view: ChatViewProtocol?
    private var messages = [ChatMessage]()
    
    init(view: ChatViewProtocol) {
        self.view = view
    }
}

extension ChatViewModel: ChatViewModelProtocol {
    func sendMessage(message: String) {
        let userMessage = ChatMessage(role: "user", content: message)
        messages.append(userMessage)
        
        displayMessage(message: userMessage)
        
        TextGenerationNetworkManager.shared.completeMessage(messages: messages) { [weak self] result in
            switch result {
            case .success(let chatMessage):
                let message = ChatMessage(role: "assistant", content: chatMessage.choices[0].message.content)
                self?.messages.append(message)
                print("ChatGPT: \(message.content)")
                self?.displayMessage(message: message)
                break
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func viewDidLoad() {
        let greetingMessage = ChatMessage(role: "assistant", content: "Hi! how can I help you?")
        messages.append(greetingMessage)
        displayMessage(message: greetingMessage)
    }
    
    private func displayMessage(message: ChatMessage) {
        let senderName: String
        let senderType: SenderType
        if message.role == "assistant" {
            senderName = "chatGPT"
            senderType = .chatGPT
        } else if message.role == "user" {
            senderName = "You"
            senderType = .user
        } else {
            senderName = "You"
            senderType = .user
        }
        
        let presentation = ChatCellPresentation(senderType: senderType,
                                                senderName: senderName,
                                                message: message.content,
                                                senderImage: nil,
                                                imageMessage: nil)
        
        view?.displayMessage(message: presentation)
    }
}
