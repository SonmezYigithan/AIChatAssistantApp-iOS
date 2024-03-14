//
//  MessageBarView.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 10.03.2024.
//

import UIKit

class MessageBarView: UIView {
    weak var chatView: ChatViewProtocol?
    
    private let micButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "mic.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "camera.fill")
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let textFieldBackground: UIView = {
        let view = UIView()
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.customBackground.cgColor
        view.layer.cornerRadius = 23
        view.clipsToBounds = true
        return view
    }()
    
    private let textView: UITextView = {
        let textField = UITextView()
        textField.font = .systemFont(ofSize: 17)
//        textField.placeholder = "Send a message"
        return textField
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "arrow.up", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold))
        button.backgroundColor = .customPurple
        button.layer.cornerRadius = 15
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareView() {
        addSubview(stackView)
        stackView.addArrangedSubview(micButton)
        stackView.addArrangedSubview(cameraButton)
        stackView.addArrangedSubview(textFieldBackground)
        textFieldBackground.addSubview(textView)
        textFieldBackground.addSubview(sendButton)
        
        sendButton.isEnabled = false
        textView.delegate = self
        
        sendButton.addTarget(self, action: #selector(sendButtonClicked), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(cameraButtonClicked), for: .touchUpInside)
        
        setupConstraints()
    }
    
    @objc private func sendButtonClicked() {
        guard let message = textView.text else { return }
        chatView?.sendButtonClicked(message: message)
        textView.text = ""
    }
    
    @objc private func cameraButtonClicked() {
        chatView?.navigateToCameraInputView()
    }
    
    func updateTextView(message: String) {
        textView.text = message
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(10)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        textFieldBackground.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(280)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(textFieldBackground.snp.top).offset(10)
            make.leading.equalTo(textFieldBackground.snp.leading).offset(15)
            make.bottom.equalTo(textFieldBackground.snp.bottom).offset(-10)
            make.trailing.equalTo(textFieldBackground.snp.trailing).offset(-25)
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-5)
            make.width.height.equalTo(28)
        }
    }
}

extension MessageBarView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            sendButton.isEnabled = false
        }else {
            sendButton.isEnabled = true
        }
    }
}
