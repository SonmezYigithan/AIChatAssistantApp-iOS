//
//  SettingsTableViewCell.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 12.03.2024.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    static let identifier = "SettingsTableViewCell"
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.tintColor = .black
        return image
    }()
    
    private let imageBackground: UIImageView = {
        let image = UIImageView()
//        image.contentMode = .scaleAspectFit
        image.backgroundColor = .customSettingsButtonBackground
        image.layer.cornerRadius = 10
        image.clipsToBounds = true
        return image
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(name: String, image: UIImage?) {
        label.text = name
        self.image.image = image
    }
    
    private func prepareView() {
        backgroundColor = .customSettingsBackground
        addSubview(label)
        addSubview(imageBackground)
        imageBackground.addSubview(image)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        imageBackground.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(25)
            make.height.equalTo(25)
        }
        
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(25)
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
    }
}
