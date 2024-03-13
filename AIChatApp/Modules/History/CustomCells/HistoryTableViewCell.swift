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
    
    private let aiImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let aiName: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    private let chatSummary: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let chatMessage: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .customGrayText
        return label
    }()
    
    private let createdAt: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .customGrayText
        return label
    }()
    
    private let starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with presentation: ChatHistoryCellPresentation) {
        if presentation.chatType == .textGeneration {
            self.aiImage.image = UIImage(systemName: "circle.fill")
        }else if presentation.chatType == .persona {
            if let image = presentation.image {
                self.aiImage.image = UIImage(named: image)
            }
        }else {
            // image generation
        }
        
        aiName.text = presentation.aiName
        chatSummary.text =  presentation.chatSummary
        chatMessage.text = presentation.chatMessage
        createdAt.text =  presentation.createdAt
        starImageView.image = presentation.isStarred ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
    }
    
    private func prepareView() {
        addSubview(aiImage)
        addSubview(aiName)
        addSubview(chatSummary)
        addSubview(chatMessage)
        addSubview(createdAt)
        addSubview(starImageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        aiImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        aiName.snp.makeConstraints { make in
            make.leading.equalTo(aiImage.snp.trailing).offset(15)
            make.top.equalToSuperview().offset(10)
        }
        
        chatSummary.snp.makeConstraints { make in
            make.leading.equalTo(aiImage.snp.trailing).offset(15)
            make.top.equalTo(aiName.snp.bottom).offset(5)
        }
        
        chatMessage.snp.makeConstraints { make in
            make.leading.equalTo(aiImage.snp.trailing).offset(15)
            make.top.equalTo(chatSummary.snp.bottom).offset(5)
        }
        
        createdAt.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
        }
        
        starImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(30)
        }
    }
}
