//
//  VideoPlayerViewModel.swift
//  SimpleYoutube
//
//  Created by George Tseng on 2025/5/7.
//

class VideoPlayerViewModel: BaseViewModel {
    private(set) var videoId: String
    private(set) var videoTitle: String = ""
    private(set) var ownerThumbnailURL: String
    private(set) var ownerTitle: String
    private(set) var uploadedDatetime: String = ""
    private(set) var videoDescription: String = ""

    private(set) var viewCount: String = ""
    private(set) var likeCount: String = ""
    private(set) var favoriteCount: String = ""
    private(set) var commentCount: String = ""

    var refreshUIHandler: (() -> Void)?

    init(videoId: String, channelSnippet: ChannelSnippet?) {
        self.videoId = videoId
        self.ownerThumbnailURL = channelSnippet?.thumbnails.medium?.url ?? ""
        self.ownerTitle = channelSnippet?.title ?? ""
    }

    override func start() {
        super.start()
        fetchVideo()
    }
}

extension VideoPlayerViewModel {
    func fetchVideo() {
        YoutubeApi.VideosRequest(id: videoId).send(queue: .main) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let response):
                self.videoTitle = response.items.first?.snippet.title ?? ""
                self.uploadedDatetime = response.items.first?.snippet.publishedAt.formatYouTubeDate() ?? ""
                self.videoDescription = response.items.first?.snippet.description ?? ""

                self.viewCount = response.items.first?.statistics?.viewCount ?? ""
                self.likeCount = response.items.first?.statistics?.likeCount ?? ""
                self.favoriteCount = response.items.first?.statistics?.favoriteCount ?? ""
                self.commentCount = response.items.first?.statistics?.commentCount ?? ""

                self.refreshUIHandler?()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
