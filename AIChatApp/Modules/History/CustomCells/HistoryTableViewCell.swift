//
//  HistoryTableViewCell.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 13.03.2024.
//

import UIKit
import SnapKit

class HistoryTableViewCell: UITableViewCell {
    static let identifier = "HistoryTableViewCell"
    weak var viewModel: HistoryViewModelProtocol?
    var index: Int = 0
    var isStarred = false
    
    private let aiImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let aiName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private let chatTitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    private let chatMessage: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textColor = .customGrayText
        return label
    }()
    
    private let createdAt: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .customGrayText
        return label
    }()
    
    private let starButton: UIButton = {
        let button = UIButton()
        button.tintColor = .customGrayText
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with presentation: ChatHistoryCellPresentation) {
        isStarred = presentation.isStarred
        
        if let image = presentation.image {
            self.aiImage.image = UIImage(named: image)
        }
        
        aiName.text = presentation.aiName
        chatTitle.text =  presentation.chatTitle ?? "New Chat"
        chatMessage.text = presentation.chatMessage
        createdAt.text =  presentation.createdAt
        
        if presentation.isStarred {
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            starButton.tintColor = .customGreenText
        }else {
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
        
        starButton.addTarget(self, action: #selector(starButtonTapped), for: .touchUpInside)
    }
    
    private func prepareView() {
        addSubview(aiImage)
        addSubview(aiName)
        addSubview(chatTitle)
        addSubview(chatMessage)
        addSubview(createdAt)
        contentView.addSubview(starButton)
        
        setupConstraints()
    }
    
    @objc private func starButtonTapped() {
        if isStarred {
            viewModel?.unStarChat(at: index)
            starButton.setImage(UIImage(systemName: "star"), for: .normal)
            starButton.tintColor = .customGrayText
            isStarred = false
        }else {
            viewModel?.starChat(at: index)
            starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            starButton.tintColor = .customGreenText
            isStarred = true
        }
    }
    
    private func setupConstraints() {
        aiImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        aiName.snp.makeConstraints { make in
            make.leading.equalTo(aiImage.snp.trailing).offset(15)
            make.top.equalToSuperview().offset(10)
        }
        
        chatTitle.snp.makeConstraints { make in
            make.leading.equalTo(aiImage.snp.trailing).offset(15)
            make.trailing.equalTo(starButton.snp.leading).offset(-10)
            make.top.equalTo(aiName.snp.bottom).offset(5)
        }
        
        chatMessage.snp.makeConstraints { make in
            make.leading.equalTo(aiImage.snp.trailing).offset(15)
            make.trailing.equalTo(starButton.snp.leading).offset(-10)
            make.top.equalTo(chatTitle.snp.bottom).offset(5)
        }
        
        createdAt.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
        }
        
        starButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalTo(createdAt.snp.bottom).offset(10)
            make.width.height.equalTo(23)
        }
    }
}
