//
//  AdaptersCore.swift
//  FirstWallet
//
//  Created by George Tseng on 2025/2/28.
//

import Foundation

/// 構建請求結構的抽象化協議
protocol RequestAdapter {
    /// 組件新的請求
    /// - Parameter request: 現有的請求結構
    /// - Returns: 新的請求結構
    func adapted(_ request: URLRequest) throws -> URLRequest
}

/// 自定義構建請求內容
struct AnyAdapter: RequestAdapter {
    /// 自定請求結構
    let closure: (URLRequest) throws -> URLRequest

    func adapted(_ request: URLRequest) throws -> URLRequest {
        return try closure(request)
    }
}
