//
//  TextGenerationNetworkManager.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 11.03.2024.
//

import Alamofire

protocol TextGenerationNetworkManagerProtocol {
    
}

final class TextGenerationNetworkManager {
    static let shared = TextGenerationNetworkManager()
    
    func convertChatMessagesToParameters(messages: [ChatMessage]) -> Parameters {
        // Convert array of ChatMessages to array of dictionaries
        let jsonMessages = messages.map { message in
            return [
                "role": message.role,
                "content": message.content
            ]
        }

        // Create Parameters object
        var parameters: Parameters = [
            "model": "gpt-3.5-turbo"
        ]

        // Add messages to parameters if not empty
        if !jsonMessages.isEmpty {
            parameters["messages"] = jsonMessages
        }

        return parameters
    }
    
    func completeMessage(messages: [ChatMessage], completion: @escaping (Result<ChatGPTResponse, Error>) -> ()) {
        let urlEndpoint = OpenAINetworkHelper.shared.baseURL + "chat/completions"
        
        let parameters = convertChatMessagesToParameters(messages: messages)
        
        NetworkManager.shared.request(ChatGPTResponse.self, url: urlEndpoint, method: .post, parameters: parameters, headers: OpenAINetworkHelper.shared.headers()) { result in
            switch result {
            case .success(let responseMessage):
                completion(.success(responseMessage))
            case .failure(let error):
                print(error)
            }
        }
    }
}
