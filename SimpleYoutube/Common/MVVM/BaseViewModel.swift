//
//  BaseViewModel.swift
//  FirstWallet
//
//  Created by George Tseng on 2025/1/31.
//

import Foundation
import UIKit

protocol BaseViewModelProtocol {
    func start()
    func viewWillAppear()
    func viewDidAppear()
    func viewWillDisappear()
    func viewDidDisappear()
}

class BaseViewModel: NSObject, BaseViewModelProtocol {
    var isViewAppeared: Bool = false

    @objc dynamic func start() {
    }

    @objc dynamic func viewWillAppear() {
    }

    @objc dynamic func viewDidAppear() {
        isViewAppeared = true
    }

    @objc dynamic func viewWillDisappear() {
    }

    @objc dynamic func viewDidDisappear() {
        isViewAppeared = false
    }
}
