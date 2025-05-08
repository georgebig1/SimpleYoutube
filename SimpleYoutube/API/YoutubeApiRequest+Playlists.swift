//
//  YoutubeApiRequest+Playlists.swift
//  SimpleYoutube
//
//  Created by George Tseng on 2025/5/6.
//

import Foundation

extension YoutubeApi {
    struct PlaylistsRequest: YoutubeApiRequest {
        typealias Response = PlaylistItemResponse

        let path: String = "playlistItems"

        let method = HTTPMethod.GET

        var parameters: [String: Any]

        let contentType = ContentType.json

        init(id: String, nextPageToken: String?) {
            parameters = [
                "part": "snippet",
                "playlistId": id,
                "maxResults": 30
            ]
            if let nextPageToken {
                parameters["pageToken"] = nextPageToken
                parameters["maxResults"] = 20
            }
        }
    }
}
