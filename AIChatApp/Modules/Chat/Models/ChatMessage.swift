//
//  ChatMessage.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 10.03.2024.
//

import UIKit

struct ChatMessage {
    let senderType: SenderType
    let senderName: String
    let message: String
    let senderImage: UIImage?
    let imageMessage: [UIImage]?
}
