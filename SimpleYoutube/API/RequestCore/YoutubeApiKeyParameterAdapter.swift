//
//  YoutubeApiKeyParameterAdapter.swift
//  SimpleYoutube
//
//  Created by George Tseng on 2025/5/6.
//

struct YoutubeApiKeyParameterAdapter: ParameterAdapter {

    func adapted(_ parameter: [String: Any]) throws -> [String: Any] {
        var parameter = parameter
        parameter["key"] = AppConfig.youtubeAPIKey
        return parameter
    }
}
