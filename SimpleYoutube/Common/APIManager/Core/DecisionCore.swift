//
//  DecisionCore.swift
//  FirstWallet
//
//  Created by George Tseng on 2025/2/28.
//

import Foundation

/// 建構收到回應後執行決策的抽象化協議
protocol Decision {
    /// 判別是否執行此決策
    /// - Parameters:
    ///   - request: 發出的請求
    ///   - data: 收到的回應內容
    ///   - response: 收到的回應
    /// - Returns: `true` 則執行此決策；反之則判斷下一個決策
    func shouldApply<Req: Request>(request: Req, data: Data, response: HTTPURLResponse) -> Bool

    /// 執行決策
    /// - Parameters:
    ///   - request: 發出的請求
    ///   - data: 收到的回應內容
    ///   - response: 收到的回應
    ///   - closure: 完成決策後的動作
    func apply<Req: Request>(request: Req,
                             data: Data,
                             response: HTTPURLResponse,
                             done closure: @escaping (DecisionAction<Req>) -> Void)
}

/// 執行決策後的動作
enum DecisionAction<Req: Request> {
    /// 繼續下一個決策
    case continueWith(Data, HTTPURLResponse)
    /// 帶入新的決策，重新進行請求
    case restartWith([Decision])
    /// 拋出錯誤
    case errored(Error)
    /// 正常完成請求，後續的決策全數不執行
    case done(Req.Response)
}

/// Log 決策
protocol LogDecision {
    /// 判別是否執行此決策
    /// - Parameters:
    ///   - request: 發出的請求
    ///   - logInfo: Log 資訊
    /// - Returns: `true` 則執行此決策；反之則判斷下一個決策
    func shouldApply<Req: Request>(request: Req, logInfo: LogInfo) -> Bool

    /// 執行決策
    /// - Parameters:
    ///   - request: 發出的請求
    ///   - logInfo: Log 資訊
    func apply<Req: Request>(request: Req, logInfo: LogInfo)
}

struct LogInfo {
    let request: URLRequest

    let originalRequestDate: Date
    let realRequestDate: Date

    let responseDate: Date

    var response: HTTPURLResponse?
    let data: Data?
    let error: Error?
}

extension Array where Element == Decision {
    func removing(_ item: Decision) -> Array {
        return self.replacing(item, with: nil)
    }

    func replacing(_ item: Decision, with newItem: Decision?) -> Array {
        var decisions = self
        guard let index = decisions.firstIndex(where: { type(of: $0) == type(of: item) }) else { return self }
        _ = decisions.remove(at: index)
        if let newItem = newItem {
            decisions.insert(newItem, at: index)
        }
        return decisions
    }
}
