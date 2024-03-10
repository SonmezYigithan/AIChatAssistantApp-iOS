//
//  StoreTableViewCell.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 10.03.2024.
//

import UIKit

final class StoreTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    static let identifier = "StoreTableViewCell"
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 15
        image.backgroundColor = .customBackground
        image.clipsToBounds = true
        return image
    }()
    
    private let aiNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Doctor"
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    private let aiDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Here's your lovely doctor who takes care of you"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .customGrayText
        label.numberOfLines = 2
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("TRY", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.setTitleColor(.customGreenText, for: .normal)
        button.layer.cornerRadius = 15
        button.backgroundColor = .customGreenBackground
        return button
    }()
    
    // MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareView() {
        addSubview(image)
        addSubview(aiNameLabel)
        addSubview(aiDescriptionLabel)
        addSubview(button)
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        image.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.leading.equalTo(snp.leading).offset(15)
        }
        
        aiNameLabel.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(15)
            make.leading.equalTo(image.snp.trailing).offset(15)
            make.trailing.equalTo(button.snp.leading).offset(-15)
        }
        
        aiDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(aiNameLabel.snp.bottom).offset(3)
            make.leading.equalTo(image.snp.trailing).offset(15)
            make.trailing.equalTo(button.snp.leading).offset(-15)
        }
        
        button.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.width.equalTo(60)
            make.height.equalTo(35)
            make.centerY.equalToSuperview()
        }
    }
}
