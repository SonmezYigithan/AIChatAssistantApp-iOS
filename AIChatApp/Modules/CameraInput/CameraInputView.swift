//
//  CameraInputView.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 13.03.2024.
//

import UIKit
import AVFoundation

protocol CameraInputViewProtocol: AnyObject {
    var previewLayer: AVCaptureVideoPreviewLayer { get set }
    
    func finishProcessingPhoto(image: UIImage)
    func showAlertMessage(alert: UIAlertController)
    func dismissView()
}

class CameraInputView: UIViewController {
    // MARK: - Properties
    var viewModel: CameraInputViewModelProtocol?
    
    var previewLayer = AVCaptureVideoPreviewLayer()
    
    private let label: UILabel = {
        let label = UILabel()
        label.text = "Take a picture of a question"
        return label
    }()
    
    private let photoPreviewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.isHidden = true
        return imageView
    }()
    
    private let shutterButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 10
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.viewDidLoad()
        prepareView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
    }
    
    private func prepareView() {
        view.backgroundColor = .black
        previewLayer.backgroundColor = UIColor.black.cgColor
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        view.addSubview(photoPreviewImageView)
        
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        
        createMaskedView()
        view.bringSubviewToFront(shutterButton)
        
        setupConstraints()
    }
    
    @objc private func didTapTakePhoto() {
        viewModel?.didTapTakePhoto()
    }
    
    private func createMaskedView() {
        // Create a view that covers the entire screen
        let view = UIView(frame: self.view.bounds)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        // Create a path with a rectangle with rounded corners
        let path = UIBezierPath(roundedRect: CGRect(x: 50, y: 200, width: view.frame.width - 100, height: 400), cornerRadius: 20)
        
        // Create a path that covers the entire screen
        let fullPath = UIBezierPath(rect: view.bounds)
        
        fullPath.append(path)
        let maskLayer = CAShapeLayer()
        maskLayer.path = fullPath.cgPath
        maskLayer.fillRule = .evenOdd
        
        view.layer.mask = maskLayer
        self.view.addSubview(view)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        shutterButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-100)
            make.width.height.equalTo(100)
        }
        
        photoPreviewImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension CameraInputView: CameraInputViewProtocol {
    func finishProcessingPhoto(image: UIImage) {
        photoPreviewImageView.image = image
        photoPreviewImageView.isHidden = false
        
        // Crop image
        // think like x and y coordinates swapped.
        // so in order to move crop in y axis, increase x
        let rect = CGRect(x: image.size.width / 8, y: 0, width: image.size.width / 3, height: image.size.height).integral
        let cropImage = viewModel?.cropImage(image, toRect: rect, viewWidth: view.frame.width, viewHeight: view.frame.height)
        if let cropImage = cropImage {
            viewModel?.recognizeText(in: cropImage)
        }
    }
    
    func showAlertMessage(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
    
    func dismissView() {
        navigationController?.popViewController(animated: true)
    }
}
