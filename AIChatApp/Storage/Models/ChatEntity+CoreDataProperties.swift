//
//  ChatEntity+CoreDataProperties.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 14.03.2024.
//
//

import Foundation
import CoreData


extension ChatEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatEntity> {
        return NSFetchRequest<ChatEntity>(entityName: "ChatEntity")
    }

    @NSManaged public var aiImage: String?
    @NSManaged public var aiName: String?
    @NSManaged public var chatId: String
    @NSManaged public var chatTitle: String?
    @NSManaged public var chatType: Int64
    @NSManaged public var createdAt: Date
    @NSManaged public var greeting: String?
    @NSManaged public var isStarred: Bool
    @NSManaged public var startPrompt: String?
    @NSManaged public var messages: [ChatMessageEntity]?

}

// MARK: Generated accessors for messages
extension ChatEntity {

    @objc(insertObject:inMessagesAtIndex:)
    @NSManaged public func insertIntoMessages(_ value: ChatMessageEntity, at idx: Int)

    @objc(removeObjectFromMessagesAtIndex:)
    @NSManaged public func removeFromMessages(at idx: Int)

    @objc(insertMessages:atIndexes:)
    @NSManaged public func insertIntoMessages(_ values: [ChatMessageEntity], at indexes: NSIndexSet)

    @objc(removeMessagesAtIndexes:)
    @NSManaged public func removeFromMessages(at indexes: NSIndexSet)

    @objc(replaceObjectInMessagesAtIndex:withObject:)
    @NSManaged public func replaceMessages(at idx: Int, with value: ChatMessageEntity)

    @objc(replaceMessagesAtIndexes:withMessages:)
    @NSManaged public func replaceMessages(at indexes: NSIndexSet, with values: [ChatMessageEntity])

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: ChatMessageEntity)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: ChatMessageEntity)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSOrderedSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSOrderedSet)

}

extension ChatEntity : Identifiable {

}
