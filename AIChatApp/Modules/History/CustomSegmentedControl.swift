//
//  CustomSegmentedControl.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 14.03.2024.
//

import UIKit

protocol CustomSegmentedControlDelegate {
    func selectedSegment(index: Int)
}

/// https://stackoverflow.com/questions/45391386/customize-segmented-control-or
class CustomSegmentedControl: UIView {
    private enum Constants {
        static let segmentedControlHeight: CGFloat = 40
        static let underlineViewColor: UIColor = .customGreenText
        static let underlineViewHeight: CGFloat = 2
    }
    
    var delegate: CustomSegmentedControlDelegate?
    
    private let line: UIView = {
        let view = UIView()
        view.backgroundColor = .customGrayText
        return view
    }()

    // Container view of the segmented control
    private lazy var segmentedControlContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .clear
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    func selectSegment(index: Int) {
        segmentedControl.selectedSegmentIndex = index
        segmentedControlValueChanged(segmentedControl)
    }

    // Customised segmented control
    private lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl()

        // Remove background and divider colors
        segmentedControl.backgroundColor = .white
        segmentedControl.layer.shadowOpacity = 0
        segmentedControl.layer.borderWidth = 0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            for i in 0...(segmentedControl.numberOfSegments-1)  {
                let backgroundSegmentView = segmentedControl.subviews[i]
                //it is not enough changing the background color. It has some kind of shadow layer
                backgroundSegmentView.isHidden = true
                backgroundSegmentView.layer.shadowOpacity = 0
                backgroundSegmentView.layer.borderWidth = 0
            }
        }
        
        segmentedControl.tintColor = .customGreenText
        segmentedControl.selectedSegmentTintColor = .white

        // Append segments
        segmentedControl.insertSegment(withTitle: "All", at: 0, animated: true)
        segmentedControl.insertSegment(withTitle: "Starred", at: 1, animated: true)

        // Select first segment by default
        segmentedControl.selectedSegmentIndex = 0

        // Change text color and the font of the NOT selected (normal) segment
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .regular)], for: .normal)

        // Change text color and the font of the selected segment
        segmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16, weight: .medium)], for: .selected)

        // Set up event handler to get notified when the selected segment changes
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)

        // Return false because we will set the constraints with Auto Layout
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()

    // The underline view below the segmented control
    private lazy var bottomUnderlineView: UIView = {
        let underlineView = UIView()
        underlineView.backgroundColor = Constants.underlineViewColor
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        return underlineView
    }()

    private lazy var leadingDistanceConstraint: NSLayoutConstraint = {
        return bottomUnderlineView.leftAnchor.constraint(equalTo: segmentedControl.leftAnchor)
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        // Add subviews to the view hierarchy
        // (both segmentedControl and bottomUnderlineView are subviews of the segmentedControlContainerView)
        addSubview(segmentedControlContainerView)
        addSubview(line)
        segmentedControlContainerView.addSubview(segmentedControl)
        segmentedControlContainerView.addSubview(bottomUnderlineView)

        // Constrain the container view to the view controller
        let safeLayoutGuide = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            segmentedControlContainerView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            segmentedControlContainerView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            segmentedControlContainerView.widthAnchor.constraint(equalTo: safeLayoutGuide.widthAnchor),
            segmentedControlContainerView.heightAnchor.constraint(equalToConstant: Constants.segmentedControlHeight)
            ])

        // Constrain the segmented control to the container view
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: segmentedControlContainerView.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: segmentedControlContainerView.leadingAnchor),
            segmentedControl.trailingAnchor.constraint(equalTo: segmentedControlContainerView.trailingAnchor, constant: -200),
            segmentedControl.centerYAnchor.constraint(equalTo: segmentedControlContainerView.centerYAnchor)
            ])

        // Constrain the underline view relative to the segmented control
        NSLayoutConstraint.activate([
            bottomUnderlineView.bottomAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
            bottomUnderlineView.heightAnchor.constraint(equalToConstant: Constants.underlineViewHeight),
            leadingDistanceConstraint,
            bottomUnderlineView.widthAnchor.constraint(equalTo: segmentedControl.widthAnchor, multiplier: 1 / CGFloat(segmentedControl.numberOfSegments))
            ])
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        line.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-16)
            make.width.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        delegate?.selectedSegment(index: sender.selectedSegmentIndex)
        changeSegmentedControlLinePosition()
    }

    // Change position of the underline
    private func changeSegmentedControlLinePosition() {
        let segmentIndex = CGFloat(segmentedControl.selectedSegmentIndex)
//        let segmentWidth = segmentedControl.frame.width / CGFloat(segmentedControl.numberOfSegments)
        let segmentWidth = 100.0
        let leadingDistance = segmentWidth * segmentIndex
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.leadingDistanceConstraint.constant = leadingDistance
        })
    }
}
