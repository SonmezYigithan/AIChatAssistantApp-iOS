//
//  LimitedTimeOfferView.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 15.03.2024.
//

import UIKit

class LimitedTimeOfferView: UIView {
    private let title: UILabel = {
        let label = UILabel()
        label.text = "Limited Time Offers"
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Chat with Taylor Swift about her latest album"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .customBackground
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "taylorswift")
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("TRY", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.setTitleColor(.customGreenBackground, for: .normal) //customGreenText
        button.layer.cornerRadius = 15
        button.backgroundColor = .customGreenText
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareView() {
        addSubview(title)
        addSubview(cardView)
        cardView.addSubview(descriptionLabel)
        cardView.addSubview(imageView)
        cardView.addSubview(button)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        title.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(15)
            make.leading.equalTo(snp.leading).offset(15)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(5)
            make.leading.equalTo(snp.leading).offset(15)
            make.trailing.equalTo(snp.trailing).offset(-15)
        }
        
        cardView.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(15)
            make.leading.bottom.trailing.equalToSuperview().inset(15)
        }
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(15)
            make.width.height.equalTo(120)
        }
        
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(60)
            make.height.equalTo(35)
            make.top.equalTo(descriptionLabel.snp.bottom).offset(5)
        }
    }
}
