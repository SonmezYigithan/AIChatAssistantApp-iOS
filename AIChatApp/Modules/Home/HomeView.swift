//
//  HomeView.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 8.03.2024.
//

import UIKit
import SnapKit

protocol HomeViewProtocol: AnyObject {
    func navigateTo(route: HomeViewRoutes)
}

final class HomeView: UIViewController {
    // MARK: - Properties
    private lazy var viewModel: HomeViewModelProtocol = HomeViewModel(view: self)
    
    private let historyButton: UIButton = {
        let button = UIButton()
        let customButtonView = ButtonWithImageView()
        customButtonView.configure(labelText: "History", image: UIImage(systemName: "clock.arrow.circlepath"))
        button.addSubview(customButtonView)
        
        customButtonView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return button
    }()
    
    private let chatButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customBackground
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        return button
    }()
    
    private let cameraButton: UIButton = {
        let button = UIButton()
        let image = UIImageView()
        image.image = UIImage(systemName: "camera.fill")
        image.tintColor = .white
        image.contentMode = .scaleAspectFit
        button.addSubview(image)
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        }
        
        button.backgroundColor = .customGray
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        return button
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Type Here..."
        label.textColor = UIColor.black
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.tintColor = .systemGreen
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let separator = SeparatorLineHomeView()
    
    private let imageGenerationButton: UIButton = {
        let button = UIButton()
        let labelTop = UILabel()
        let labelBottom = UILabel()
        let image = UIImageView()
        let imageBackground = UIView()
        
        button.addSubview(labelTop)
        button.addSubview(labelBottom)
        button.addSubview(imageBackground)
        imageBackground.addSubview(image)
        
        labelTop.text = "Image Generation"
        labelTop.font = .systemFont(ofSize: 14)
        labelBottom.text = "TEXT-TO-IMAGE"
        labelBottom.font = .systemFont(ofSize: 12)
        labelBottom.textColor = .customGrayText
        
        imageBackground.backgroundColor = .white
        imageBackground.layer.cornerRadius = 15
        imageBackground.layer.masksToBounds = true
        
        image.image = UIImage(systemName: "rectangle.dashed")
        image.tintColor = .green
        image.contentMode = .scaleAspectFit
        image.backgroundColor = .white
        
        button.backgroundColor = .customBackground
        button.layer.cornerRadius = 30
        button.layer.masksToBounds = true
        
        image.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
        }
        
        imageBackground.snp.makeConstraints { make in
            make.leading.equalTo(button.snp.leading).offset(15)
            make.centerY.equalTo(button.snp.centerY)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        labelTop.snp.makeConstraints { make in
            make.top.equalTo(button.snp.top).offset(10)
            make.leading.equalTo(image.snp.trailing).offset(10)
        }
        
        labelBottom.snp.makeConstraints { make in
            make.top.equalTo(labelTop.snp.bottom).offset(5)
            make.leading.equalTo(image.snp.trailing).offset(10)
        }
        
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 15
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func prepareView() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(historyButton)
        view.addSubview(stackView)
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(chatButton)
        stackView.setCustomSpacing(35, after: chatButton)
        stackView.addArrangedSubview(separator)
        stackView.setCustomSpacing(35, after: separator)
        stackView.addArrangedSubview(imageGenerationButton)
        chatButton.addSubview(label)
        chatButton.addSubview(cameraButton)
        
        chatButton.addTarget(self, action: #selector(chatButtonClicked), for: .touchUpInside)
        cameraButton.addTarget(self, action: #selector(cameraButtonClicked), for: .touchUpInside)
        historyButton.addTarget(self, action: #selector(historyButtonClicked), for: .touchUpInside)
    }
    
    @objc private func chatButtonClicked() {
        viewModel.chatButtonClicked()
    }
    
    @objc private func cameraButtonClicked() {
        viewModel.cameraButtonClicked()
    }
    
    @objc private func historyButtonClicked() {
        viewModel.historyButtonClicked()
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        historyButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(15)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.width.equalTo(100)
            make.height.equalTo(35)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(80)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(30)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-30)
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
        
        chatButton.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(30)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-30)
            make.height.equalTo(70)
        }
        
        cameraButton.snp.makeConstraints { make in
            make.trailing.equalTo(chatButton.snp.trailing).offset(-15)
            make.centerY.equalTo(chatButton.snp.centerY)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        
        imageGenerationButton.snp.makeConstraints { make in
            make.width.equalTo(220)
            make.height.equalTo(60)
        }
        
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10))
        }
    }
}

extension HomeView: HomeViewProtocol {
    func navigateTo(route: HomeViewRoutes) {
        switch route {
        case .chat(let vc):
            show(vc, sender: self)
        case .cameraInput(let vc):
            show(vc, sender: self)
            vc.navigateToCameraInputView()
        case .history(let vc):
            show(vc, sender: self)
        }
    }
}
