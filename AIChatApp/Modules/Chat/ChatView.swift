//
//  ChatView.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 8.03.2024.
//

import UIKit

final class ChatView: UIViewController {
    //MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
    }
    
    private func prepareView() {
        view.backgroundColor = .systemBackground
        title = "Chat"
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        
    }
}
