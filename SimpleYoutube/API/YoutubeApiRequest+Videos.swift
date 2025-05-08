//
//  YoutubeApiRequest+Videos.swift
//  SimpleYoutube
//
//  Created by George Tseng on 2025/5/7.
//

import Foundation

extension YoutubeApi {
    struct VideosRequest: YoutubeApiRequest {
        typealias Response = VideoResponse

        let path: String = "videos"

        let method = HTTPMethod.GET

        var parameters: [String: Any]

        let contentType = ContentType.json

        init(id: String) {
            parameters = [
                "part": "statistics,snippet",
                "id": id
            ]
        }
    }
}
