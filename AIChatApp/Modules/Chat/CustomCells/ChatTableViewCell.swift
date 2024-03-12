//
//  CatTableViewCell.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 10.03.2024.
//

import UIKit

enum SenderType {
    case user
    case chatGPT
    case persona
    case imageGenerator
}

struct ChatCellPresentation {
    let senderType: SenderType
    let senderName: String
    let message: String
    let imageMessage: [UIImage]?
}

class ChatTableViewCell: UITableViewCell {
    // MARK: - Properties
    static let identifier = "ChatUserTableViewCell"
    
    private var senderType: SenderType = .user
    
    let senderNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    let chatImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(senderNameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(chatImageView)
        
        setupConstraints()
    }
    
    override func prepareForReuse() {
        backgroundColor = .systemBackground
    }
    
    func configure(with presentation: ChatCellPresentation) {
        senderNameLabel.text = presentation.senderName
        messageLabel.text = presentation.message
        self.senderType = presentation.senderType
        
        configureStyle(senderType: presentation.senderType, personaName: presentation.senderName)
    }
    
    private func configureStyle(senderType: SenderType, personaName: String) {
        if senderType == .chatGPT {
            backgroundColor = .customBackground
            chatImageView.image = UIImage(systemName: "circle.fill")
            chatImageView.tintColor = .customChatGPTGreen
        }else if senderType == .user {
            chatImageView.image = UIImage(systemName: "person.crop.circle.fill")
        }else if senderType == .persona {
            // show persona image
            chatImageView.image = PersonaManager.shared.getPersonaImage(of: personaName)
            backgroundColor = .customBackground
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        chatImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(15)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        senderNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.equalTo(chatImageView.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-10)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(senderNameLabel.snp.bottom).offset(15)
            make.bottom.equalToSuperview().offset(-15)
            make.leading.equalTo(chatImageView.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
}
