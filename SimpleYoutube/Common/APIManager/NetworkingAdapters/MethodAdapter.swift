//
//  MethodAdapter.swift
//  FirstWallet
//
//  Created by George Tseng on 2025/2/28.
//

import Foundation

extension HTTPMethod {
    var adapter: AnyAdapter {
        return AnyAdapter { req in
            var req = req
            req.httpMethod = rawValue
            return req
        }
    }
}
