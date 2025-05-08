//
//  YoutubeApiRequest+Channels.swift
//  SimpleYoutube
//
//  Created by George Tseng on 2025/5/6.
//

import Foundation

extension YoutubeApi {
    struct ChannelsRequest: YoutubeApiRequest {
        typealias Response = ChannelResponse

        let path: String = "channels"

        let method = HTTPMethod.GET

        var parameters: [String: Any]

        let contentType = ContentType.json

        init() {
            parameters = [
                "part": "contentDetails,snippet",
                "id": AppConfig.youtubeChannelId
            ]
        }
    }
}
