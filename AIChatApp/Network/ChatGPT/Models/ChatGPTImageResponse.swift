//
//  ChatGPTImageResponse.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 14.03.2024.
//

import Foundation

struct ChatGPTImageResponse: Codable {
    let created: Int
    let data: [Data]?
}

struct Data: Codable {
    let url: String
}
