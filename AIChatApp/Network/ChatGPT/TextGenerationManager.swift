//
//  TextGenerationNetworkManager.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 11.03.2024.
//

import Alamofire

final class TextGenerationManager {
    static let shared = TextGenerationManager()
    
    private func convertChatMessagesToParameters(messages: [ChatMessage]) -> Parameters {
        // Convert array of ChatMessages to array of dictionaries
        let jsonMessages = messages.map { message in
            return [
                "role": message.role,
                "content": message.content
            ]
        }

        var parameters: Parameters = [
            "model": "gpt-3.5-turbo"
        ]

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
    
    func completeMessageAsPersona(messages: [ChatMessage], personaPrompt: ChatMessage, completion: @escaping (Result<ChatGPTResponse, Error>) -> ()) {
        let urlEndpoint = OpenAINetworkHelper.shared.baseURL + "chat/completions"
        var chatMessages = messages
        chatMessages.insert(personaPrompt, at: 0)
        let parameters = convertChatMessagesToParameters(messages: chatMessages)
        
        NetworkManager.shared.request(ChatGPTResponse.self, url: urlEndpoint, method: .post, parameters: parameters, headers: OpenAINetworkHelper.shared.headers()) { result in
            switch result {
            case .success(let responseMessage):
                completion(.success(responseMessage))
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func generateChatTitle(chatId: String, messages: [ChatMessage], completion: @escaping (Result<ChatGPTResponse, Error>) -> ()) {
        let urlEndpoint = OpenAINetworkHelper.shared.baseURL + "chat/completions"
        
        let prompt = ChatMessage(role: "user", content: "generete me a chat title for this conversation. don't include anything in response. Only include message in quotation marks")
        var chatMessages = messages
        chatMessages.append(prompt)
        let parameters = convertChatMessagesToParameters(messages: chatMessages)
        
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
