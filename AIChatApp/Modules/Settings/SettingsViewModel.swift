//
//  SettingsViewModel.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 12.03.2024.
//

import Foundation
import UIKit

protocol SettingsViewModelProtocol {
    func clickedMoreAppsLink(link: String)
}

class SettingsViewModel {
}

extension SettingsViewModel: SettingsViewModelProtocol {
    func clickedMoreAppsLink(link: String) {
        if let url = URL(string: link), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Invalid URL or unable to open the URL")
        }
    }
}
