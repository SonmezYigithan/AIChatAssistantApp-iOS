//
//  SeperatorLineHome.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 8.03.2024.
//

import UIKit

final class SeparatorLineHomeView: UIView {
    let orLabel: UILabel = {
        let label = UILabel()
        label.text = "or"
        label.textAlignment = .center
        return label
    }()
    
    let leftLine: UIView = {
        let view = UIView()
        view.backgroundColor = .customBackground
        return view
    }()
    
    let rightLine: UIView = {
        let view = UIView()
        view.backgroundColor = .customBackground
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(orLabel)
        addSubview(leftLine)
        addSubview(rightLine)
        
        setupConstraints()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyGradient(on: leftLine, startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5))
        applyGradient(on: rightLine, startPoint: CGPoint(x: 1, y: 0.5), endPoint: CGPoint(x: 0, y: 0.5))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func applyGradient(on view: UIView, startPoint: CGPoint, endPoint: CGPoint) {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.clear.cgColor, UIColor.gray.cgColor, UIColor.clear.cgColor]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        view.layer.mask = gradient
    }
    
    private func setupConstraints() {
        orLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        leftLine.snp.makeConstraints { make in
            make.centerY.equalTo(orLabel)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(orLabel.snp.left).offset(-10)
            make.height.equalTo(2)
        }
        
        rightLine.snp.makeConstraints { make in
            make.centerY.equalTo(orLabel)
            make.right.equalToSuperview().offset(-20)
            make.left.equalTo(orLabel.snp.right).offset(10)
            make.height.equalTo(2)
        }
    }
}
