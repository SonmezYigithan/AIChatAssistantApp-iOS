//
//  ChatViewBuilder.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 10.03.2024.
//

import Foundation

final class ChatViewBuilder {
    static func make(chatParameters: ChatParameters) -> ChatView {
        let view = ChatView()
        let viewModel = ChatViewModel(view: view, chatParameters: chatParameters)
        view.viewModel = viewModel
        view.hidesBottomBarWhenPushed = true
        return view
    }
}
