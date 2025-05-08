//
//  RequestContentAdapter.swift
//  FirstWallet
//
//  Created by George Tseng on 2025/2/28.
//

import Foundation

struct RequestContentAdapter: RequestAdapter {
    let method: HTTPMethod
    let contentType: ContentType
    let content: [String: Any]

    func adapted(_ request: URLRequest) throws -> URLRequest {
        switch method {
        case .GET:
            return try URLQueryDataAdapter(data: content).adapted(request)
        case .POST:
            let headerAdapter = contentType.headerAdapter
            let dataAdapter = contentType.dataAdapter(for: content)
            let req = try headerAdapter.adapted(request)
            return try dataAdapter.adapted(req)
        }
    }
}

struct URLQueryDataAdapter: RequestAdapter {
    let data: [String: Any]

    func adapted(_ request: URLRequest) throws -> URLRequest {
        var request = request

        guard let url = request.url,
              var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            throw RequestError.invalidURL
        }

        var queryItems = urlComponents.queryItems ?? []
        queryItems += data.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        urlComponents.queryItems = queryItems

        request.url = urlComponents.url
        return request
    }
}

struct JSONRequestDataAdapter: RequestAdapter {
    let data: [String: Any]

    func adapted(_ request: URLRequest) throws -> URLRequest {
        var request = request
        request.httpBody = try JSONSerialization.data(withJSONObject: data, options: [])
        return request
    }
}

struct URLFormRequestDataAdapter: RequestAdapter {
    let data: [String: Any]

    func adapted(_ request: URLRequest) throws -> URLRequest {
        var request = request

        var urlComponents = URLComponents()
        urlComponents.queryItems = data.map { URLQueryItem(name: $0.key, value: "\($0.value)") }

        request.httpBody = urlComponents.query?.data(using: .utf8)
        return request
    }
}

extension ContentType {
    var headerAdapter: AnyAdapter {
        return AnyAdapter { req in
            var req = req
            req.setValue(rawValue, forHTTPHeaderField: "Content-Type")
            return req
        }
    }

    func dataAdapter(for data: [String: Any]) -> RequestAdapter {
        switch self {
        case .json:
            return JSONRequestDataAdapter(data: data)
        case .urlForm:
            return URLFormRequestDataAdapter(data: data)
        }
    }
}
