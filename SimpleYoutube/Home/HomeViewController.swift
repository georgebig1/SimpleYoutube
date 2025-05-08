//
//  ViewController.swift
//  SimpleYoutube
//
//  Created by George Tseng on 2025/5/6.
//

import UIKit

class HomeViewController: BaseViewController<HomeViewModel> {
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: String(describing: HomeTableViewCell.self))
        return tableView
    }()
}

extension HomeViewController {
    override func setupUI() {
        super.setupUI()

        title = "Simple Youtube"
        view.backgroundColor = .white

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }

    override func bindViewModel() {
        super.bindViewModel()

        viewModel.refreshPlaylistHandler = { [weak self] in
            guard let self else { return }

            self.tableView.reloadData()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellViewmodels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard indexPath.row < viewModel.cellViewmodels.count,
              let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: HomeTableViewCell.self)) as? HomeTableViewCell
        else { return UITableViewCell() }

        cell.config(viewModel: viewModel.cellViewmodels[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vm = viewModel.createVideoPlayerViewModel(forItemIndex: indexPath.row) {
            let vc = VideoPlayerViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == viewModel.cellViewmodels.count - 2 { // 倒數第2個
            viewModel.fetchPlaylist(loadMore: true)
        }
    }
}
