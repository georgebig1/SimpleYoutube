//
//  SimpleYoutubeTests.swift
//  SimpleYoutubeTests
//
//  Created by George Tseng on 2025/5/6.
//

import XCTest
@testable import SimpleYoutube

class SimpleYoutubeTests: XCTestCase {
    var homeViewModel: HomeViewModel!
    var mockChannelResponse: ChannelResponse!
    var mockPlaylistResponse: PlaylistItemResponse!

    override func setUp() {
        super.setUp()
        homeViewModel = HomeViewModel()
        mockChannelResponse = loadMockChannelResponse()
        mockPlaylistResponse = loadMockPlaylistResponse()
    }

    override func tearDown() {
        homeViewModel = nil
        mockChannelResponse = nil
        mockPlaylistResponse = nil
        super.tearDown()
    }

    func testChannelInfoCaching() {
        UserDefaults.standard.setObject(mockChannelResponse, forKey: .channel)
        XCTAssertNotNil(UserDefaults.standard.getObject(forKey: .channel, as: ChannelResponse.self))
        print("Channel info cached correctly")
    }

    func testPlaylistCaching() {
        UserDefaults.standard.setObject(mockPlaylistResponse, forKey: .playlist)
        XCTAssertNotNil(UserDefaults.standard.getObject(forKey: .playlist, as: PlaylistItemResponse.self))
        print("Playlist cached correctly")
    }

    func testCreateVideoPlayerViewModel() {
        homeViewModel.handleChanelResponse(mockChannelResponse)
        homeViewModel.handlePlaylistResponse(mockPlaylistResponse, loadMore: false)

        let viewModel = homeViewModel.createVideoPlayerViewModel(forItemIndex: 0)
        XCTAssertNotNil(viewModel)
        XCTAssertEqual(viewModel?.videoId, mockPlaylistResponse.items.first?.snippet.resourceId.videoId)
        print("Video player view model created correctly")
    }

    func testFetchChannelInfo() {
        let expectation = self.expectation(description: "Channel Info Fetched")

        homeViewModel.refreshPlaylistHandler = { [weak self] in
            XCTAssertNotNil(self?.homeViewModel.channelSnippet)
            XCTAssertNotNil(self?.homeViewModel.uploadsPlaylistId)
            print("Channel info fetched correctly")
            expectation.fulfill()
        }

        homeViewModel.fetchChannelInfo()

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchPlaylist() {
        let expectation = self.expectation(description: "Playlist Fetched")

        homeViewModel.handleChanelResponse(mockChannelResponse)

        homeViewModel.refreshPlaylistHandler = { [weak self] in
            XCTAssertGreaterThan(self?.homeViewModel.cellViewmodels.count ?? 0, 0)
            print("Playlist fetched correctly")
            expectation.fulfill()
        }

        homeViewModel.fetchPlaylist(loadMore: false)

        waitForExpectations(timeout: 5, handler: nil)
    }

    func testFetchVideo() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self else { return }
            let expectation = self.expectation(description: "Video Fetched")

            let viewModel = self.homeViewModel.createVideoPlayerViewModel(forItemIndex: 0)
            XCTAssertNotNil(viewModel)

            viewModel?.refreshUIHandler = {
                XCTAssertGreaterThan(viewModel?.videoTitle.count ?? 0, 0)
                print("Video fetched correctly")
                expectation.fulfill()
            }

            viewModel?.fetchVideo()

            self.waitForExpectations(timeout: 5, handler: nil)
        }
    }

    // MARK: - Mock Data Loaders
    private func loadMockChannelResponse() -> ChannelResponse {
        let json = """
        {
            "items": [{
                "id": "Test ID",
                "snippet": {"title": "Test Channel", "thumbnails": {"medium": {"url": "https://example.com/image.jpg"}}},
                "contentDetails": {"relatedPlaylists": {"uploads": "UU1234567890"}}
            }]
        }
        """
        let data = json.data(using: .utf8)!
        return try! JSONDecoder().decode(ChannelResponse.self, from: data)
    }

    private func loadMockPlaylistResponse() -> PlaylistItemResponse {
        let json = """
        {
            "nextPageToken": "CAUQAA",
            "items": [{
                "snippet": {
                    "title": "Test Video",
                    "publishedAt": "2025-05-08T14:00:00Z",
                    "thumbnails": {"medium": {"url": "https://example.com/video.jpg"}},
                    "resourceId": {"videoId": "abc123"},
                    "channelTitle": "Test Channel Title"
                }
            }]
        }
        """
        let data = json.data(using: .utf8)!
        return try! JSONDecoder().decode(PlaylistItemResponse.self, from: data)
    }
}
