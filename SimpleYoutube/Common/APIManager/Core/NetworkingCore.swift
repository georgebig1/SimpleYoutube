//
//  NetworkingCore.swift
//  FirstWallet
//
//  Created by George Tseng on 2025/2/28.
//

import Foundation

private let priorityGroup = DispatchGroup()
private let semaphore = DispatchSemaphore(value: 10)

// MARK: - Client
struct HTTPClient {
    let session: URLSession

    /// 發送請求
    /// - Parameters:
    ///   - request: API 請求結構
    ///   - decisions: 收到回應後需執行的決策。如果為 nil，則使用預設決策
    ///   - handler: 執行決策後的結果
    func send<Req: Request>(_ request: Req,
                            decisions: [Decision]? = nil,
                            queue: DispatchQueue,
                            handler: @escaping (Result<Req.Response, Error>) -> Void) {
        let originalRequestDate = Date()

        DispatchQueue.global().async {
            var request = request

            if request.priority == RequestPriority.criticalPriority {
                priorityGroup.enter()
            } else {
                priorityGroup.wait()
                semaphore.wait()
            }

            let urlRequest: URLRequest
            do {
                try request.attachMoreParameter()
                urlRequest = try request.buildRequest()
            } catch {
                queue.async {
                    handler(.failure(error))
                }
                return
            }

            let realRequestDate = Date()
            let task = session.dataTask(with: urlRequest) { data, response, error in
                var logInfo = LogInfo(request: urlRequest,
                                      originalRequestDate: originalRequestDate,
                                      realRequestDate: realRequestDate,
                                      responseDate: Date(),
                                      data: data,
                                      error: error)
                defer {
                    request.logDecisions.forEach {
                        guard $0.shouldApply(request: request, logInfo: logInfo) else { return }
                        $0.apply(request: request, logInfo: logInfo)
                    }
                    if request.priority == RequestPriority.criticalPriority {
                        priorityGroup.leave()
                    }
                }

                if request.priority != .criticalPriority {
                    semaphore.signal()
                }

                guard let data else {
                    queue.async {
                        handler(.failure(error ?? ResponseError.nilData))
                    }
                    return
                }

                guard let response = response as? HTTPURLResponse else {
                    queue.async {
                        handler(.failure(ResponseError.nonHTTPResponse))
                    }
                    return
                }
                logInfo.response = response

                handleDecision(request,
                               data: data,
                               response: response,
                               decisions: decisions ?? request.decisions,
                               queue: queue,
                               handler: handler)
            }
            task.priority = min(1, max(0, request.priority.rawValue))
            task.resume()
        }
    }

    // swiftlint:disable:next function_parameter_count
    private func handleDecision<Req: Request>(_ request: Req,
                                              data: Data,
                                              response: HTTPURLResponse,
                                              decisions: [Decision],
                                              queue: DispatchQueue,
                                              handler: @escaping (Result<Req.Response, Error>) -> Void) {
        guard decisions.isEmpty == false else { fatalError("沒有適用的決策") }

        var decisions = decisions
        let current = decisions.removeFirst()

        guard current.shouldApply(request: request, data: data, response: response) else {
            handleDecision(request,
                           data: data,
                           response: response,
                           decisions: decisions,
                           queue: queue,
                           handler: handler)
            return
        }

        current.apply(request: request, data: data, response: response) { action in
            switch action {
            case .continueWith(let data, let response):
                handleDecision(request,
                               data: data,
                               response: response,
                               decisions: decisions,
                               queue: queue,
                               handler: handler)
            case .restartWith(let decisions):
                send(request, decisions: decisions, queue: queue, handler: handler)
            case .errored(let error):
                queue.async {
                    handler(.failure(error))
                }
            case .done(let value):
                queue.async {
                    handler(.success(value))
                }
            }
        }
    }
}

// MARK: - Protocol-Based Request
/// API 請求結構協議
///
/// 實作可依照下列範例：
///
///     struct PostRequest: Request {
///         typealias Response = PostResponse
///
///         let baseUrl = URL(string: "https://xxx.com/")
///         let path = "apipath/endpoint"
///         let method = HTTPMethod.POST
///         let contentType = ContentType.json
///
///         var parameters: [String: Any] {
///             return ["foo": foo]
///         }
///
///         let foo: String
///     }
///
///     let request = PostRequest(foo: "bar")
protocol Request {
    /// 收到正常回應的格式
    associatedtype Response: Codable

    /// API Server 路徑
    var baseURL: URL? { get }
    /// API 路徑
    var path: String { get }
    /// API HTTP 方法
    var method: HTTPMethod { get }
    /// 請求參數
    var parameters: [String: Any] { get set }
    /// 參數格式
    var contentType: ContentType { get }
    /// 額外的標頭
    var extraHeader: [String: String] { get }

    /// 連線優先級
    var priority: RequestPriority { get }
    /// 請求超時設定
    var timeout: TimeInterval { get }
    /// 請求端口
    var client: HTTPClient { get }

    /// 「調整」請求參數的組合器
    ///
    /// 可以用下列方式配置預設組合器
    ///
    ///     extension Request {
    ///         var parameterAdapters: [ParameterAdapter] {
    ///             return []
    ///         }
    ///     }
    var parameterAdapters: [ParameterAdapter] { get }

    /// 「建構」請求的組合器
    ///
    /// 可以用下列方式配置預設建構請求
    ///
    ///     extension Request {
    ///         var adapters: [RequestAdapter] {
    ///             return [
    ///                 method.adapter,
    ///                 RequestDefaultHeaderAdapter(),
    ///                 RequestExtraHeaderAdapter(extraHeader: extraHeader),
    ///                 RequestContentAdapter(method: method, contentType: contentType, content: parameters),
    ///             ]
    ///         }
    ///     }
    var adapters: [RequestAdapter] { get }

    /// 收到回應後，「依序」要執行的決策
    ///
    /// 可以用下列方式配置預設決策
    ///
    ///     extension Request {
    ///         var decisions: [Decision] {
    ///             return [
    ///                 RetryDecision(leftCount: 1),
    ///                 DataMappingDecision { $0.isEmpty } transform: { _ in
    ///                     "{}".data(using: .utf8)!
    ///                 },
    ///                 BadResponseStatusCodeDecision<DefaultBadResponseAPIError>(),
    ///                 ParseResultDecision(),
    ///             ]
    ///         }
    ///     }
    var decisions: [Decision] { get }

    var logDecisions: [LogDecision] { get }

    func send(decisions: [Decision]?,
              queue: DispatchQueue,
              handler: @escaping (Result<Response, Error>) -> Void)
}

extension Request {
    var url: URL? { return URL(string: path, relativeTo: baseURL) }

    var priority: RequestPriority { return RequestPriority.defaultPriority }

    var extraHeader: [String: String] { [:] }

    func send(decisions: [Decision]? = nil,
              queue: DispatchQueue,
              handler: @escaping (Result<Response, Error>) -> Void) {
        executeSend(decisions: decisions, queue: queue, handler: handler)
    }

    func executeSend(decisions: [Decision]? = nil,
                     queue: DispatchQueue,
                     handler: @escaping (Result<Response, Error>) -> Void) {
        client.send(self, decisions: decisions, queue: queue, handler: handler)
    }
}

extension Request {
    mutating func attachMoreParameter() throws {
        parameters = try parameterAdapters.reduce(parameters) { try $1.adapted($0) }
    }

    func buildRequest() throws -> URLRequest {
        guard let url else { throw RequestError.invalidURL }
        let request = URLRequest(url: url)
        return try adapters.reduce(request) { try $1.adapted($0) }
    }
}
