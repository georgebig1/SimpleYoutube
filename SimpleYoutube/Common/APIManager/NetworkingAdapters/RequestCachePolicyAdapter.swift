//
//  RequestCachePolicyAdapter.swift
//  FirstWallet
//
//  Created by Jacob on 2025/3/5.
//

import Foundation

struct RequestCachePolicyAdapter: RequestAdapter {
    let cachePolicy: URLRequest.CachePolicy

    func adapted(_ request: URLRequest) throws -> URLRequest {
        var request = request
        request.cachePolicy = cachePolicy
        return request
    }
}
