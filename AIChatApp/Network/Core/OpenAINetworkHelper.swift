//
//  OpenAINetworkHelper.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 11.03.2024.
//

import Foundation

import Alamofire

final class OpenAINetworkHelper {
    static let shared = OpenAINetworkHelper()
    
    private let apiKeys = APIKeys(resourceName: "API-Keys")
    
    let baseURL = "https://api.openai.com/v1/"
    
    func headers() -> HTTPHeaders{
        ["Authorization": "Bearer \(apiKeys.openAiAPIKey)",
         "Content-Type": "application/json"
        ]
    }
}
