//
//  NetworkingType.swift
//  FirstWallet
//
//  Created by George Tseng on 2025/2/28.
//

import Foundation

// MARK: - Request
enum HTTPMethod: String {
    case GET
    case POST
}

enum ContentType: String {
    case json = "application/json"
    case urlForm = "application/x-www-form-urlencoded"
}

enum RequestError: Error {
    /// 無法建立 URL
    case invalidURL
}

// MARK: - Response
/// 回應錯誤類型
enum ResponseError: Error {
    /// 伺服器有回應，但無內容
    case nilData
    /// 伺服器有回應，但不是標準 HTTP 協議的定義
    case nonHTTPResponse
    /// token 失效
    case tokenError
    /// API 業務格式錯誤
    case apiError(error: APIError, statusCode: Int)
}

/// API 業務格式錯誤回應介面，請依需求實作
protocol APIError: Decodable { }

/// 連線優先級
struct RequestPriority: RawRepresentable {
    /// 優先等級，有效範圍 0 至 1。當值為 `Float.infinity` 代表絕對優先。
    var rawValue: Float

    /// 自定級別，有效範圍 0 至 1
    init(rawValue: Float) {
        self.rawValue = rawValue
    }

    /// 自定級別，有效範圍 0 至 1
    init(_ rawValue: Float) {
        self.rawValue = rawValue
    }
}

extension RequestPriority {
    /// 絕對優先，會暫緩其它尚未請求的連線，直至當前連線完成
    static let criticalPriority = RequestPriority(Float.infinity)

    /// 一般級別，其值為 0.5
    static let defaultPriority = RequestPriority(URLSessionTask.defaultPriority)

    /// 低級別，其值為 0
    static let lowPriority = RequestPriority(URLSessionTask.lowPriority)

    /// 高級別，其值為 1
    static let highPriority = RequestPriority(URLSessionTask.highPriority)
}

// MARK: Equatable
extension RequestPriority: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }

    static func != (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue != rhs.rawValue
    }
}
