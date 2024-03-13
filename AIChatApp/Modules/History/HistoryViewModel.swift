//
//  HistoryViewModel.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 13.03.2024.
//

import Foundation

protocol HistoryViewModelProtocol {
    func fetchAllChatHistory()
}

final class HistoryViewModel {
    weak var view: HistoryViewProtocol?
    var chatEntities = [ChatEntity]()
    
    init(view: HistoryViewProtocol) {
        self.view = view
    }
}

extension HistoryViewModel: HistoryViewModelProtocol {
    func fetchAllChatHistory() {
        guard let chatEntities = ChatSaveManager.shared.loadAllChats() else { return }
        self.chatEntities = chatEntities
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        
        let chatHistoryPresentation = chatEntities.map {
            let createdAtString: String
            if let createdAt = $0.createdAt {
                createdAtString = dateFormatter.string(from: createdAt)
            } else {
                createdAtString = ""
            }
            
            var chatTypeValue: ChatType = .textGeneration
            if let chatType = ChatType(rawValue: Int($0.chatType)) {
                chatTypeValue = chatType
            }
            
            var chatMessage = ""
            if let messages = $0.messages {
                if let last = messages.last {
                    chatMessage = last.textMessage ?? ""
                }
            }
            
            return ChatHistoryCellPresentation(aiName: $0.aiName ?? "",
                                        chatSummary: nil,
                                        chatMessage: chatMessage,
                                        createdAt: createdAtString,
                                        isStarred: $0.isStarred,
                                        image: $0.aiImage,
                                        chatType: chatTypeValue)}
        
        view?.showChatHistory(with: chatHistoryPresentation)
    }
}
