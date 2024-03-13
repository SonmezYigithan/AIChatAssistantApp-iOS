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
        chatEntity.chatId = chatParameters.chatId
        chatEntity.chatType = Int64(chatParameters.chatType.rawValue)
        chatEntity.startPrompt = chatParameters.startPrompt
        chatEntity.isStarred = chatParameters.isStarred
        chatEntity.createdAt = chatParameters.createdAt
        //        chatEntity.aiImage = chatParameters.aiImage // TODO: Instead of Using UIImage() use String to store AI Images
        
        do {
            try context.save()
            print("CoreData: Created new chat \(chatParameters.chatId)")
        }
        catch let error as NSError{
            print(error)
        }
    }
    
    func deleteChat(chatId: String) {
        let predicate = NSPredicate(format: "chatId == %@", chatId)
        let fetchRequest = ChatEntity.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let list = try context.fetch(fetchRequest)
            if let firstEntity = list.first, list.count > 0 {
                if let messages = firstEntity.messages {
                    for message in messages {
                        context.delete(message)
                    }
                    print("CoreData: Deleted the chat messages for chat \(chatId)")
                }
                
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
    
    func loadChatMessages(chatId: String) -> [ChatMessageEntity]? {
        let predicate = NSPredicate(format: "chatId == %@", chatId)
        let fetchRequest = ChatEntity.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let chat = try context.fetch(fetchRequest)
            if let firstChat = chat.first, chat.count > 0 {
                return firstChat.messages
            }
            return nil
        }
        catch let error as NSError{
            print(error)
            return nil
        }
    }
    
    func saveMessage(chatId: String, textMessage: String?, imageMessage: String?, isSenderUser: Bool) {
        let chatMessageEntity = ChatMessageEntity(context: context)
        chatMessageEntity.imageMessage = imageMessage
        chatMessageEntity.isSenderUser = isSenderUser
        chatMessageEntity.textMessage = textMessage
        
        let predicate = NSPredicate(format: "chatId == %@", chatId)
        let fetchRequest = ChatEntity.fetchRequest()
        fetchRequest.predicate = predicate
        
        do {
            let chat = try context.fetch(fetchRequest)
            if let firstChat = chat.first, chat.count > 0 {
                chatMessageEntity.chat = firstChat
                try context.save()
                print("CoreData: Saved chat message to \(firstChat.chatId)")
                return
            }
            print("CoreData: Chat couldn't found \(chatId)")
        }
        catch let error as NSError{
            print(error)
        }
    }
}
