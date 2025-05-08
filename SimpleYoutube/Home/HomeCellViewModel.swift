//
//  HomeCellViewModel.swift
//  SimpleYoutube
//
//  Created by George Tseng on 2025/5/6.
//

class HomeCellViewModel: BaseViewModel, Codable {
    private(set) var videoId: String
    private(set) var thumbnailURL: String
    private(set) var videoTitle: String
    private(set) var ownerThumbnailURL: String
    private(set) var ownerTitle: String
    private(set) var uploadedDatetime: String

    init(videoId: String, thumbnailURL: String, videoTitle: String, ownerThumbnailURL: String, ownerTitle: String, uploadedDatetime: String) {
        self.videoId = videoId
        self.thumbnailURL = thumbnailURL
        self.videoTitle = videoTitle
        self.ownerThumbnailURL = ownerThumbnailURL
        self.ownerTitle = ownerTitle
        self.uploadedDatetime = uploadedDatetime.formatYouTubeDate()
    }
}
