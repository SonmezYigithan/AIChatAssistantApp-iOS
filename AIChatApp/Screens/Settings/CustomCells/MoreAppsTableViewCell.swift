//
//  MoreAppsTableViewCell.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 12.03.2024.
//

import UIKit

class MoreAppsTableViewCell: UITableViewCell {
    static let identifier = "MoreAppsTableViewCell"
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .customSettingsBackground
        view.layer.cornerRadius = 15
        return view
    }()
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .customBackground
        image.layer.cornerRadius = 15
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
    
    private func prepareView() {
        backgroundColor = .systemBackground
        addSubview(containerView)
        containerView.addSubview(image)
        containerView.addSubview(label)
        
        setupConstraints()
    }
    
    func configure(name: String, image: UIImage?) {
        label.text = name
        self.image.image = image
    }
    
    private func setupConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(3)
            make.leading.trailing.equalToSuperview()
        }
        
        image.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(image.snp.trailing).offset(15)
            make.trailing.equalToSuperview().offset(-15)
            make.centerY.equalToSuperview()
        }
    }
}
