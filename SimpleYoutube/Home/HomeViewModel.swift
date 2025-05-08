//
//  HomeViewModel.swift
//  SimpleYoutube
//
//  Created by George Tseng on 2025/5/6.
//

import Foundation

class HomeViewModel: BaseViewModel {
    private(set) var channelSnippet: ChannelSnippet?
    private(set) var uploadsPlaylistId: String?
    private var nextPageToken: String?

    private(set) var cellViewmodels: [HomeCellViewModel] = [] {
        didSet {
            refreshPlaylistHandler?()
        }
    }

    var refreshPlaylistHandler: (() -> Void)?

    override func start() {
        super.start()
        fetchChannelInfo()
    }

    override func viewWillAppear() {
        super.viewWillAppear()

    }
}

extension HomeViewModel {
    func fetchChannelInfo() {
        YoutubeApi.ChannelsRequest().send(queue: .main) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let response):
                UserDefaults.standard.setObject(response, forKey: .channel)
                self.handleChanelResponse(response)
            case .failure(let error):
                print(error.localizedDescription)
                if let response = UserDefaults.standard.getObject(forKey: .channel, as: ChannelResponse.self) {
                    self.handleChanelResponse(response)
                }
            }
        }
    }

    func fetchPlaylist(loadMore: Bool) {
        guard let playlistId = self.uploadsPlaylistId else { return }

        if loadMore, nextPageToken == nil {
            // 沒有更多資料了
            return
        }

        YoutubeApi.PlaylistsRequest(id: playlistId, nextPageToken: nextPageToken).send(queue: .main) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let response):
                UserDefaults.standard.setObject(response, forKey: .playlist)
                self.handlePlaylistResponse(response, loadMore: loadMore)
            case .failure(let error):
                print(error.localizedDescription)
                if let response = UserDefaults.standard.getObject(forKey: .playlist, as: PlaylistItemResponse.self) {
                    self.handlePlaylistResponse(response, loadMore: loadMore)
                }
            }
        }
    }
}

extension HomeViewModel {
    func handleChanelResponse(_ response: ChannelResponse) {
        if let channel = response.items.first {
            self.channelSnippet = channel.snippet
            self.uploadsPlaylistId = channel.contentDetails.relatedPlaylists.uploads
            self.fetchPlaylist(loadMore: false)
        }
    }

    func handlePlaylistResponse(_ response: PlaylistItemResponse, loadMore: Bool) {
        self.nextPageToken = response.nextPageToken
        let vms = response.items.compactMap({ item in
            return HomeCellViewModel(
                videoId: item.snippet.resourceId.videoId,
                thumbnailURL: item.snippet.thumbnails.medium?.url ?? "",
                videoTitle: item.snippet.title,
                ownerThumbnailURL: self.channelSnippet?.thumbnails.medium?.url ?? "",
                ownerTitle: self.channelSnippet?.title ?? "",
                uploadedDatetime: item.snippet.publishedAt)
        })

        if loadMore {
            self.cellViewmodels.append(contentsOf: vms)
        } else {
            self.cellViewmodels = vms
        }
    }
}

extension HomeViewModel {
    func createVideoPlayerViewModel(forItemIndex index: Int) -> VideoPlayerViewModel? {
        guard index < cellViewmodels.count else { return nil }

        let item = cellViewmodels[index]
        return VideoPlayerViewModel(videoId: item.videoId, channelSnippet: channelSnippet)
    }
}
