//
//  YoutubeApiRequest.swift
//  SimpleYoutube
//
//  Created by George Tseng on 2025/5/6.
//

import Foundation

struct YoutubeApi { }

protocol YoutubeApiRequest: Request {}

extension YoutubeApiRequest {
    var baseURL: URL? {
        let urlString = AppConfig.youtubeAPIBaseURL
        return URL(string: urlString)
    }
    var timeout: TimeInterval { return 30 }
    var client: HTTPClient { return HTTPClient(session: .shared) }
}

// MARK: - ParameterAdapter
extension YoutubeApiRequest {
    var parameterAdapters: [ParameterAdapter] {
        return [
            YoutubeApiKeyParameterAdapter()
        ]
    }
}

// MARK: - RequestAdapter
extension YoutubeApiRequest {
    var adapters: [RequestAdapter] {
        return [
            method.adapter,
            RequestExtraHeaderAdapter(extraHeader: extraHeader),
            RequestContentAdapter(method: method, contentType: contentType, content: parameters),
            RequestTimeoutAdapter(timeout: timeout)
        ]
    }
}

// MARK: - Decision
extension YoutubeApiRequest {
    var decisions: [Decision] {
        return [
            RetryDecision(leftCount: 1),
            DataMappingDecision { $0.isEmpty } transform: { _ in
                Data("{}".utf8)
            },
            YoutubeApiParseResultDecision(),
            YoutubeApiErrorDecision()
        ]
    }

    var logDecisions: [LogDecision] {
        return []
    }
}
