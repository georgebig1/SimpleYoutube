//
//  ParameterAdaptersCore.swift
//  FirstWallet
//
//  Created by George Tseng on 2025/2/28.
//

import Foundation

/// 請整請求參數的抽象化協議
protocol ParameterAdapter {
    /// 組建新的參數
    /// - Parameter parameter: 現有的參數
    /// - Returns: 新的參數
    func adapted(_ parameter: [String: Any]) throws -> [String: Any]
}
