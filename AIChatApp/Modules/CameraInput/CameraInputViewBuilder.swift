//
//  CameraInputViewBuilder.swift
//  AIChatApp
//
//  Created by Yiğithan Sönmez on 14.03.2024.
//

import UIKit

final class CameraInputViewBuilder {
    static func make(delegate: CameraInputDelegate) -> CameraInputView {
        let view = CameraInputView()
        let viewModel = CameraInputViewModel(view: view)
        view.viewModel = viewModel
        viewModel.delegate = delegate
        view.hidesBottomBarWhenPushed = true
        return view
    }
}
