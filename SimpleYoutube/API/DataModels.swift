//
//  DataModels.swift
//  SimpleYoutube
//
//  Created by George Tseng on 2025/5/6.
//

import Foundation

// MARK: - Channel

struct ChannelResponse: Codable {
    let items: [Channel]
}

struct Channel: Codable {
    let id: String
    let snippet: ChannelSnippet
    let contentDetails: ChannelContentDetails
}

struct ChannelSnippet: Codable {
    let title: String
    let thumbnails: ThumbnailContainer
}

struct ChannelContentDetails: Codable {
    let relatedPlaylists: RelatedPlaylists
}

struct RelatedPlaylists: Codable {
    let uploads: String
}

// MARK: - Playlist Items

struct PlaylistItemResponse: Codable {
    let nextPageToken: String?
    let items: [PlaylistItem]
}

struct PlaylistItem: Codable {
    let snippet: PlaylistSnippet
}

struct PlaylistSnippet: Codable {
    let title: String
    let publishedAt: String
    let thumbnails: ThumbnailContainer
    let resourceId: ResourceId
    let channelTitle: String
}

struct ResourceId: Codable {
    let videoId: String
}

// MARK: - Video Detail

struct VideoResponse: Codable {
    let items: [Video]
}

struct Video: Codable {
    let id: String
    let snippet: VideoSnippet
    let statistics: VideoStatistics?
}

struct VideoSnippet: Codable {
    let title: String
    let channelTitle: String
    let description: String
    let publishedAt: String
    let thumbnails: ThumbnailContainer
}

struct VideoStatistics: Codable {
    let viewCount: String
    let likeCount: String
    let favoriteCount: String
    let commentCount: String
}

// MARK: - Thumbnails

struct ThumbnailContainer: Codable {
    let medium: Thumbnail?
    let high: Thumbnail?
}

struct Thumbnail: Codable {
    let url: String
    let width: Int?
    let height: Int?
}
