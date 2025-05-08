//
//  BaseView.swift
//  FirstWallet
//
//  Created by George Tseng on 2025/2/23.
//

import Foundation
import UIKit

protocol BaseViewProtocol: UIView {
    func setupUI()
    func bindViewModel()
}

class BaseView<ViewModel: BaseViewModel>: UIView, BaseViewProtocol {
    let viewModel: ViewModel

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
        bindViewModel()
        viewModel.start()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - MVVM
    @objc dynamic func setupUI() {
    }

    @objc dynamic func bindViewModel() {
    }
}
