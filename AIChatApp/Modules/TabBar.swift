//
//  TabBar.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 8.03.2024.
//

import UIKit

class TabBar: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemYellow
        
        let vc1 = UINavigationController(rootViewController: StoreView())
        let vc2 = UINavigationController(rootViewController: HomeView())
        let vc3 = UINavigationController(rootViewController: SettingsView())
        
        vc1.tabBarItem.image = UIImage(systemName: "rectangle.grid.2x2")
        vc2.tabBarItem.image = UIImage(systemName: "text.bubble.fill")
        vc3.tabBarItem.image = UIImage(systemName: "line.3.horizontal")
        
        vc1.title = "Store"
        vc2.title = "Chat"
        vc3.title = "More"
        
        tabBar.tintColor = .label
                
        setViewControllers([vc1, vc2, vc3], animated: true)
        
//        selectedIndex = 1
    }
}
