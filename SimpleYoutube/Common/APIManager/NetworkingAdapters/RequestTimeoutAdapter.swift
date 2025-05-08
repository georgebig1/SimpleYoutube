//
//  RequestTimeoutAdapter.swift
//  FirstWallet
//
//  Created by George Tseng on 2025/2/28.
//

import Foundation

/// 設定 timeout
struct RequestTimeoutAdapter: RequestAdapter {
    let timeout: TimeInterval

    func adapted(_ request: URLRequest) throws -> URLRequest {
        var request = request
        request.timeoutInterval = timeout
        return request
    }
}
