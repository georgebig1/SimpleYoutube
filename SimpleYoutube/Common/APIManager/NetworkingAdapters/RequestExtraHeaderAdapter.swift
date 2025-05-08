//
//  RequestExtraHeaderAdapter.swift
//  FirstWallet
//
//  Created by George Tseng on 2025/2/28.
//

import Foundation

struct RequestExtraHeaderAdapter: RequestAdapter {
    let extraHeader: [String: String]

    func adapted(_ request: URLRequest) throws -> URLRequest {
        var request = request
        extraHeader.forEach {
            request.setValue($0.value, forHTTPHeaderField: $0.key)
        }
        return request
    }
}
