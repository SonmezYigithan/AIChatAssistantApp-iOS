//
//  StoreViewModel.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 10.03.2024.
//

import UIKit

protocol StoreViewModelProtocol: AnyObject {
    func viewDidLoad()
    func selectExpert(at row: Int)
    func selectCelebrity(at index: Int, section: Int)
}

final class StoreViewModel {
    weak var view: StoreViewProtocol?
    
    var celebrities = [Persona]()
    var experts = [Persona]()
    
    init(view: StoreViewProtocol) {
        self.view = view
    }
}

extension StoreViewModel: StoreViewModelProtocol {
    func viewDidLoad() {
        celebrities = PersonaManager.shared.getAllCelebrities()
        let celebrityPresenter = celebrities.map { PersonaPresenter(name: $0.name, description: $0.description, image: $0.image) }
        view?.showCelebrities(personas: celebrityPresenter)
        
        experts = PersonaManager.shared.getAllExperts()
        let expertPresenter = experts.map { PersonaPresenter(name: $0.name, description: $0.description, image: $0.image) }
        view?.showExperts(personas: expertPresenter)
    }
    
    func selectExpert(at index: Int) {
        let persona = experts[index]
        navigateToPersonaChat(persona: persona)
    }
    
    func selectCelebrity(at index: Int, section: Int) {
        let absoluteIndex = section * 3 + index
        let persona = celebrities[absoluteIndex]
        navigateToPersonaChat(persona: persona)
    }
    
    private func navigateToPersonaChat(persona: Persona) {
        let chatParameters = ChatParameters(chatType: .persona, aiName: persona.name, aiImage: persona.image, startPrompt: persona.prompt, isStarred: false, createdAt: Date.now, chatId: UUID().uuidString, greetingMessage: persona.greetingMessage, chatTitle: nil)
        ChatSaveManager.shared.createChat(chatParameters: chatParameters)
        let vc = ChatViewBuilder.make(chatParameters: chatParameters)
        view?.navigateToChatView(vc: vc)
    }
}
