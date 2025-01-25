//
//  ChatMessageEntity+CoreDataProperties.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 14.03.2024.
//
//

import Foundation
import CoreData


extension ChatMessageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatMessageEntity> {
        return NSFetchRequest<ChatMessageEntity>(entityName: "ChatMessageEntity")
    }

    @NSManaged public var imageMessage: String?
    @NSManaged public var isSenderUser: Bool
    @NSManaged public var textMessage: String?
    @NSManaged public var chat: ChatEntity?

}

extension ChatMessageEntity : Identifiable {

}
