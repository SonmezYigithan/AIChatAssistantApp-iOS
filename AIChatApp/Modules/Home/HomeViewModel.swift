//
//  HomeViewModel.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 8.03.2024.
//

import Foundation

enum HomeViewRoutes {
    case chat(ChatView)
    case cameraInput
    case history(HistoryView)
}

protocol HomeViewModelProtocol {
    func chatButtonClicked()
    func cameraButtonClicked()
    func historyButtonClicked()
}

final class HomeViewModel {
    weak var view: HomeViewProtocol?
    
    init(view: HomeViewProtocol) {
        self.view = view
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    func historyButtonClicked() {
        let vc = HistoryView()
        view?.navigateTo(route: .history(vc))
    }
    
    func chatButtonClicked() {
        let chatParameters = ChatParameters(chatType: .textGeneration,
                                            aiName: "ChatGPT",
                                            aiImage: nil,
                                            startPrompt: nil,
                                            isStarred: false,
                                            createdAt: Date.now,
                                            chatId: UUID().uuidString)
        let vc = ChatViewBuilder.make(chatParameters: chatParameters)
        ChatSaveManager.shared.createChat(chatParameters: chatParameters)
        view?.navigateTo(route: .chat(vc))
    }
    
    func cameraButtonClicked() {
        view?.navigateTo(route: .cameraInput)
    }
}
