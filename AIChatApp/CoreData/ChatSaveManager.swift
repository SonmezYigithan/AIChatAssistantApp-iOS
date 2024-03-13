//
//  ChatSaveManager.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 13.03.2024.
//

import UIKit

final class ChatSaveManager {
    static let shared = ChatSaveManager()
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func createChat(chatParameters: ChatParameters) {
        let chatEntity = ChatEntity(context: context)
        chatEntity.aiName = chatParameters.aiName
        chatEntity.chatId = UUID().uuidString
        chatEntity.chatType = Int64(chatParameters.chatType.rawValue)
        chatEntity.startPrompt = chatParameters.startPrompt
        chatEntity.isStarred = chatParameters.isStarred
        chatEntity.createdAt = chatParameters.createdAt
//        chatEntity.aiImage = chatParameters.aiImage // TODO: Instead of Using UIImage() use String to store AI Images
        
        do {
            try context.save()
            print("CoreData: Created new chat")
        }
        catch let error as NSError{
            print(error)
        }
    }
    
    func deleteChat(with chatId: String) {
        let predicate = NSPredicate(format: "chatId == %@", chatId)
        let fetchRequest = ChatMessageEntity.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let list = try context.fetch(fetchRequest)
            if let firstEntity = list.first, list.count > 0 {
                context.delete(firstEntity)
                try context.save()
                print("CoreData: Deleted the chat \(chatId)")
            }
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    func loadAllChats() -> [ChatEntity]? {
        do {
            let chats = try context.fetch(ChatEntity.fetchRequest())
            return chats
        }
        catch let error as NSError {
            print(error)
            return nil
        }
    }
    
    func loadChatMessages() {
        
    }
    
    func saveMessage() {
        
    }
}
