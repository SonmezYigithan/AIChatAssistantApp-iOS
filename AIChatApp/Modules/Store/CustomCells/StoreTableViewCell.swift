//
//  StoreTableViewCell.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 10.03.2024.
//

import UIKit

class StoreTableViewCell: UITableViewCell {
    // MARK: - Properties
    
    static let identifier = "StoreTableViewCell"
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 15
        image.backgroundColor = .customBackground
        image.clipsToBounds = true
        return image
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Heres your lovely doctor who takes care of you"
        label.numberOfLines = 2
        return label
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
        addSubview(label)
        
        applyConstraints()
    }
    
    private func applyConstraints() {
        image.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.height.equalTo(50)
            make.leading.equalTo(snp.leading).offset(15)
        }
        
        label.snp.makeConstraints { make in
            make.centerY.equalTo(snp.centerY)
            make.leading.equalTo(image.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
}
