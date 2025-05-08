//
//  RequestDefaultHeaderAdapter.swift
//  FirstWallet
//
//  Created by George Tseng on 2025/2/28.
//

import Foundation

/// 增加預設標頭
//struct RequestDefaultHeaderAdapter: RequestAdapter {
//    func adapted(_ request: URLRequest) throws -> URLRequest {
//        var request = request
//
//        request = try RequestDeviceInfoAdapter().adapted(request)
//        request = try RequestLocaleInfoAdapter().adapted(request)
//
//        return request
//    }
//}

/// 增加設備資訊
//struct RequestDeviceInfoAdapter: RequestAdapter {
//    func adapted(_ request: URLRequest) throws -> URLRequest {
//        var request = request
//        request.setValue("0", forHTTPHeaderField: "app-type")
//        return request
//    }
//}

/// 增加語系資訊
//struct RequestLocaleInfoAdapter: RequestAdapter {
//    func adapted(_ request: URLRequest) throws -> URLRequest {
//        var request = request
//        request.setValue(LanguageManager.shared.current.code, forHTTPHeaderField: "language")
//        return request
//    }
//}
