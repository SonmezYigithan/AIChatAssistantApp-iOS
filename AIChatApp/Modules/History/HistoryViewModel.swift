//
//  HistoryViewModel.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 13.03.2024.
//

import Foundation

protocol HistoryViewModelProtocol {
    func fetchAllChatHistory()
    func loadChatMessages(at index: Int)
    func deleteChat(at index: Int)
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
                                               chatSummary: "No Summary Yet",
                                               chatMessage: chatMessage,
                                               createdAt: dateFormatter.string(from: $0.createdAt),
                                               isStarred: $0.isStarred,
                                               image: $0.aiImage,
                                               chatType: chatTypeValue)}
        
        view?.showChatHistory(with: chatHistoryPresentation)
    }
    
    func loadChatMessages(at index: Int) {
        let chat = chatEntities[index]
        var chatTypeValue: ChatType = .textGeneration
        if let chatType = ChatType(rawValue: Int(chat.chatType)) {
            chatTypeValue = chatType
        }
        
        let chatMessages = ChatSaveManager.shared.loadChatMessages(chatId: chat.chatId)
        let chatParameters = ChatParameters(chatType: chatTypeValue,
                                            aiName: chat.aiName ?? "",
                                            aiImage: chat.aiImage ?? "",
                                            startPrompt: chat.startPrompt,
                                            isStarred: chat.isStarred,
                                            createdAt: chat.createdAt,
                                            chatId: chat.chatId)
        
        guard let chatMessages = chatMessages else { return }
        let vc = ChatViewBuilder.make(chatParameters: chatParameters, chatMessages: chatMessages)
        view?.showChatView(vc: vc)
    }
    
    func deleteChat(at index: Int) {
        ChatSaveManager.shared.deleteChat(chatId: chatEntities[index].chatId)
        chatEntities.remove(at: index)
    }
}
