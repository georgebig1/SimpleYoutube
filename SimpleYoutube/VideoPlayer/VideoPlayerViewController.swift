//
//  VideoPlayerViewController.swift
//  SimpleYoutube
//
//  Created by George Tseng on 2025/5/7.
//

import UIKit
import YouTubeiOSPlayerHelper

class VideoPlayerViewController: BaseViewController<VideoPlayerViewModel> {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var playerView: YTPlayerView = {
        let view = YTPlayerView()
        view.delegate = self
        return view
    }()

    private lazy var ownerThumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var videoTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 2
        return label
    }()

    private lazy var ownerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        label.textAlignment = .right
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        return label
    }()

    private lazy var statsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        label.numberOfLines = 1
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadVideo()
    }
}

extension VideoPlayerViewController {
    override func setupUI() {
        super.setupUI()

        view.backgroundColor = .black

        view.addSubview(playerView)
        view.addSubview(ownerThumbImageView)
        view.addSubview(videoTitleLabel)
        view.addSubview(ownerTitleLabel)
        view.addSubview(timeLabel)
        view.addSubview(statsLabel)

        playerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.width).multipliedBy(9.0 / 16.0)
        }

        ownerThumbImageView.snp.makeConstraints { make in
            make.top.equalTo(playerView.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(10)
            make.width.height.equalTo(40)
        }

        videoTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(ownerThumbImageView)
            make.leading.equalTo(ownerThumbImageView.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(10)
            make.height.greaterThanOrEqualTo(ownerThumbImageView.snp.height)
        }

        ownerTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(videoTitleLabel.snp.bottom).offset(10)
            make.leading.equalTo(videoTitleLabel)
            make.trailing.equalTo(timeLabel.snp.leading).offset(-8)
        }

        timeLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(ownerTitleLabel)
            make.trailing.equalToSuperview().inset(10)
        }

        statsLabel.snp.makeConstraints { make in
            make.top.equalTo(ownerTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }

        view.addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(statsLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        scrollView.addSubview(descriptionLabel)

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.trailing.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview().inset(20)
        }
    }

    override func bindViewModel() {
        super.bindViewModel()

        viewModel.refreshUIHandler = { [weak self] in
            guard let self else { return }

            ownerThumbImageView.kf.setImage(with: URL(string: self.viewModel.ownerThumbnailURL))
            videoTitleLabel.text = self.viewModel.videoTitle
            ownerTitleLabel.text = self.viewModel.ownerTitle
            timeLabel.text = self.viewModel.uploadedDatetime
            descriptionLabel.text = self.viewModel.videoDescription

            let formattedViewCount = self.formatCount(self.viewModel.viewCount)
            let formattedLikeCount = self.formatCount(self.viewModel.likeCount)
            let formattedFavoriteCount = self.formatCount(self.viewModel.favoriteCount)
            let formattedCommentCount = self.formatCount(self.viewModel.commentCount)
            self.statsLabel.text = "👁️ \(formattedViewCount)  👍 \(formattedLikeCount)  ⭐️ \(formattedFavoriteCount)  💬 \(formattedCommentCount)"
        }
    }

    private func loadVideo() {
        let playerVars: [String: Any] = [
            "playsinline": 1,
            "autoplay": 1,
            "controls": 1,
            "fs": 1
        ]
        playerView.load(withVideoId: viewModel.videoId, playerVars: playerVars)
    }

    private func formatCount(_ count: String) -> String {
        guard let number = Int(count) else { return count }

        switch number {
        case 1_000_000...:
            return String(format: "%.1fM", Double(number) / 1_000_000)
        case 1_000...:
            return String(format: "%.1fK", Double(number) / 1_000)
        default:
            return "\(number)"
        }
    }
}

extension VideoPlayerViewController: YTPlayerViewDelegate {
    // MARK: - YTPlayerViewDelegate
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.playVideo()
    }

    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        print("Player state changed: \(state.rawValue)")
    }

    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {
        print("Player error: \(error.rawValue)")
    }

    func playerViewPreferredInitialLoading(_ playerView: YTPlayerView) -> UIView? {
        let loadingView = UIActivityIndicatorView(style: .large)
        loadingView.backgroundColor = .black
        loadingView.color = .white
        loadingView.startAnimating()
        return loadingView
    }
}
