//
//  HomeViewModel.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 8.03.2024.
//

import Foundation

enum HomeViewRoutes {
    case chat
    case cameraInput
}

protocol HomeViewModelProtocol {
    func chatButtonClicked()
    func cameraButtonClicked()
}

class HomeViewModel {
    weak var view: HomeViewProtocol?
    
    init(view: HomeViewProtocol) {
        self.view = view
    }
}

extension HomeViewModel: HomeViewModelProtocol {
    func chatButtonClicked() {
        view?.navigateTo(route: .chat)
    }
    
    func cameraButtonClicked() {
        view?.navigateTo(route: .cameraInput)
    }
}
