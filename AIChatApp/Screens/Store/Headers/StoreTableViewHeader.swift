//
//  StoreTableViewHeader.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 10.03.2024.
//

import UIKit

final class StoreTableViewHeader: UITableViewHeaderFooterView {
    static let identifier = "StoreTableViewHeader"
    
    private let title: UILabel = {
        let label = UILabel()
        label.text = "Smart Experts 💡"
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Specialists at your fingertips: Expert advice on demand"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .customGrayText
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareView() {
        addSubview(title)
        addSubview(descriptionLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        title.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(15)
            make.leading.equalTo(snp.leading).offset(15)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(5)
            make.leading.equalTo(snp.leading).offset(15)
            make.trailing.equalTo(snp.trailing).offset(-15)
        }
    }
}
