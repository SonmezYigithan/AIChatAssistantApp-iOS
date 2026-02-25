//
//  ButtonWithImageView.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 13.03.2024.
//

import UIKit

class ButtonWithImageView: UIView {
    private let image: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.tintColor = .customHomeDarkGrayText
        return image
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .customHomeDarkGrayText
        return label
    }()
    
    private let backgroundView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .customBackground
        view.layer.masksToBounds = true
        return view
    }()
    
    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 5
        stack.axis = .horizontal
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(labelText: String, image: UIImage?) {
        label.text = labelText
        self.image.image = image
    }
    
    private func prepareView() {
        isUserInteractionEnabled = false
        addSubview(backgroundView)
        addSubview(stackView)
        stackView.addArrangedSubview(image)
        stackView.addArrangedSubview(label)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        image.snp.makeConstraints { make in
            make.width.equalTo(23)
        }
    }
}
