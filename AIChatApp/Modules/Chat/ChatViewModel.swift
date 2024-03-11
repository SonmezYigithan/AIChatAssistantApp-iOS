//
//  ChatViewModel.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 10.03.2024.
//

import Foundation

protocol ChatViewModelProtocol {
    var view: ChatViewProtocol? { get set }
    
    func sendMessage(message: String)
    func viewDidLoad()
}

final class ChatViewModel {
    weak var view: ChatViewProtocol?
    private var messages = [ChatCellPresentation]()
    
    init(view: ChatViewProtocol) {
        self.view = view
    }
}

extension ChatViewModel: ChatViewModelProtocol {
    func sendMessage(message: String) {
        let userMessage = ChatCellPresentation(senderType: .user,
                                                   senderName: "You",
                                                   message: message,
                                                   senderImage: nil,
                                                   imageMessage: nil)
        messages.append(userMessage)
        view?.displayMessages(with: messages)
    }
    
    func viewDidLoad() {
        let greetingMessage = ChatCellPresentation(senderType: .chatGPT,
                                                   senderName: "ChatGPT",
                                                   message: "Hi! how can I help you?",
                                                   senderImage: nil,
                                                   imageMessage: nil)
        let test = ChatCellPresentation(senderType: .user,
                                                   senderName: "You",
                                                   message: """
 Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed sit amet dui orci. Pellentesque iaculis nibh non magna facilisis luctus. Ut elementum quis mauris ut pharetra. Sed volutpat in augue sit amet hendrerit. Etiam pellentesque justo ut sem aliquet sodales. Nunc ac volutpat leo. Quisque in tincidunt nisi. Praesent efficitur, mi at ultrices malesuada, felis arcu venenatis urna, hendrerit tincidunt nulla ipsum eu elit. Quisque est nisl, mattis feugiat risus a, placerat mollis nisi. Integer pharetra in leo id fermentum. Sed ut ipsum pulvinar, mollis neque sit amet, suscipit dolor. Proin suscipit metus vel elit eleifend, nec molestie eros dictum. Quisque imperdiet leo at ipsum mollis euismod. Pellentesque et
 """,
                                                   senderImage: nil,
                                                   imageMessage: nil)
        messages.append(greetingMessage)
        messages.append(test)
        view?.displayMessages(with: messages)
    }
}
