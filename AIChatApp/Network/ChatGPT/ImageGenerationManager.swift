//
//  ImageGenerationManager.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 14.03.2024.
//

import Foundation
import Alamofire

final class ImageGenerationManager {
    static let shared = ImageGenerationManager()
    
    private func convertChatMessageToParameters(message: ChatMessage) -> Parameters {
        let parameters: Parameters = [
            "model": "dall-e-3",
            "prompt": message.content,
            "n": 1,
            "size": "1024x1024"
        ]
        
        return parameters
    }
    
    func generateImageFromMessage(message: ChatMessage, completion: @escaping (Result<ChatGPTImageResponse, Error>) -> ()) {
        let urlEndpoint = OpenAINetworkHelper.shared.baseURL + "images/generations"
        
        let parameters = convertChatMessageToParameters(message: message)
        
        NetworkManager.shared.request(ChatGPTImageResponse.self, url: urlEndpoint, method: .post, parameters: parameters, headers: OpenAINetworkHelper.shared.headers()) { result in
            switch result {
            case .success(let responseMessage):
                completion(.success(responseMessage))
            case .failure(let error):
                print(error)
            }
        }
    }
    
}
