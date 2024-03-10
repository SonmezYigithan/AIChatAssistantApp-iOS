//
//  ChatViewBuilder.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 10.03.2024.
//

import Foundation

final class ChatViewBuilder {
    static func make() -> ChatView {
        let view = ChatView()
        view.hidesBottomBarWhenPushed = true
        return view
    }
}
