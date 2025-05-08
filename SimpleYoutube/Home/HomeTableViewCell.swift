//
//  HomeTableViewCell.swift
//  SimpleYoutube
//
//  Created by George Tseng on 2025/5/6.
//

import UIKit
import Kingfisher

class HomeTableViewCell: UITableViewCell {
    private lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
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
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()

    private lazy var ownerTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
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

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func config(viewModel: HomeCellViewModel) {
        thumbImageView.kf.setImage(with: URL(string: viewModel.thumbnailURL))
        ownerThumbImageView.kf.setImage(with: URL(string: viewModel.ownerThumbnailURL))
        videoTitleLabel.text = viewModel.videoTitle
        ownerTitleLabel.text = viewModel.ownerTitle
        timeLabel.text = viewModel.uploadedDatetime
    }
}

extension HomeTableViewCell {
    private func setupUI() {
        self.selectionStyle = .none
        backgroundColor = UIColor.clear

        contentView.addSubview(thumbImageView)
        contentView.addSubview(ownerThumbImageView)
        contentView.addSubview(videoTitleLabel)
        contentView.addSubview(ownerTitleLabel)
        contentView.addSubview(timeLabel)

        thumbImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(thumbImageView.snp.width).multipliedBy(0.75)
        }

        ownerThumbImageView.snp.makeConstraints { make in
            make.top.equalTo(thumbImageView.snp.bottom).offset(10)
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
            make.bottom.equalToSuperview().inset(20)
        }

        timeLabel.snp.makeConstraints { make in
            make.top.bottom.equalTo(ownerTitleLabel)
            make.trailing.equalToSuperview().inset(10)
        }
    }
}
