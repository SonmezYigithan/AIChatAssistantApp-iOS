//
//  HomeView.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 8.03.2024.
//

import UIKit
import SnapKit

class HomeView: UIViewController {
    let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customBackground
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        return button
    }()

    let label: UILabel = {
        let label = UILabel()
        label.text = "Type Here..."
        label.textColor = UIColor.black
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.tintColor = .systemGreen
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(button)
        button.addSubview(label)
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(30)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-30)
        }
        
        button.snp.makeConstraints { make in
            make.height.equalTo(70)
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(150)
        }

        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10))
        }
    }
}
