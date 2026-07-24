//
//  CustomSegmentedControl.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 14.03.2024.
//

import UIKit

protocol CustomSegmentedControlDelegate: AnyObject {
    func selectedSegment(index: Int)
}

final class CustomSegmentedControl: UIView {
    weak var delegate: CustomSegmentedControlDelegate?

    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["All", "Starred"])
        control.selectedSegmentIndex = 0
        control.backgroundColor = .systemGray6
        control.selectedSegmentTintColor = .customGreenText
        control.setTitleTextAttributes([
            .foregroundColor: UIColor.label,
            .font: UIFont.preferredFont(forTextStyle: .subheadline)
        ], for: .normal)
        control.setTitleTextAttributes([
            .foregroundColor: UIColor.white,
            .font: UIFont.preferredFont(forTextStyle: .headline)
        ], for: .selected)
        return control
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        prepareView()
    }

    func selectSegment(index: Int) {
        segmentedControl.selectedSegmentIndex = index
        segmentedControlValueChanged(segmentedControl)
    }

    private func prepareView() {
        backgroundColor = .clear
        addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)

        segmentedControl.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        delegate?.selectedSegment(index: sender.selectedSegmentIndex)
    }
}
