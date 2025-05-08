//
//  BaseViewController.swift
//  FirstWallet
//
//  Created by George Tseng on 2025/1/31.
//

import Foundation
import UIKit
import SnapKit

protocol BaseViewControllerProtocol: UIViewController {
    var hideNavigationBar: Bool { get set }

    func pushViewController(_ viewController: BaseViewControllerProtocol, animated: Bool)

    func setupUI()
    func bindViewModel()
}

/// 基础控制器
class BaseViewController<ViewModel: BaseViewModel>: UIViewController, BaseViewControllerProtocol {
    let viewModel: ViewModel

    /// 隐藏导航栏，默认不隐藏
    var hideNavigationBar: Bool = false {
        didSet {
            navigationController?.setNavigationBarHidden(hideNavigationBar, animated: false)
        }
    }

    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle
    override func loadView() {
        super.loadView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.start()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.viewWillAppear()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewModel.viewDidAppear()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.viewModel.viewWillDisappear()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.viewModel.viewDidDisappear()
    }

    // MARK: - MVVM
    @objc dynamic func setupUI() {
    }

    @objc dynamic func bindViewModel() {
    }

    // MARK: - UI
    func pushViewController(_ viewController: BaseViewControllerProtocol, animated: Bool) {
       navigationController?.pushViewController(viewController, animated: animated)
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
}
