//
//  AppConst.swift
//  SimpleYoutube
//
//  Created by George Tseng on 2025/5/6.
//

import Foundation

class AppConfig {
    static let youtubeAPIBaseURL = "https://www.googleapis.com/youtube/v3/"
    static var youtubeAPIKey: String {
        guard let key = Bundle.main.object(forInfoDictionaryKey: "YoutubeAPIKey") as? String else {
            fatalError("YouTube API Key not found in Config.xcconfig")
        }

        if key == "your_api_key_here" || key.isEmpty {
            fatalError("YouTube API Key is not set. Please replace '__YOUR_YOUTUBE_API_KEY__' in Config.xcconfig")
        }

        if key.count != 39 {
            fatalError("Invalid YouTube API Key length. Please check your Config.xcconfig")
        }

        return key
    }
    static let youtubeChannelId = "UC0C-w0YjGpqDXGB8IHb662A"
}
