//
//  ChatMessage.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 10.03.2024.
//

import UIKit

//struct ChatMessage {
//    let senderType: SenderType
//    let senderName: String
//    let message: String
//    let senderImage: UIImage?
//    let imageMessage: [UIImage]?
//}


struct ChatMessage {
    let role: String
    let content: String
}

struct ChatGPTResponse: Codable {
    let id, object, model: String
    let choices: [Choice]
}

struct Choice: Codable {
    let message: Message
    let finishReason: String

    enum CodingKeys: String, CodingKey {
        case message
        case finishReason = "finish_reason"
    }
}

struct Message: Codable {
    let role, content: String
}
