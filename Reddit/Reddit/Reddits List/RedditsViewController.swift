//
//  MasterViewController.swift
//  Reddit
//
//  Created by Leandro Perez on 9/13/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import UIKit
import Reddit_api
import Base

class RedditsViewController: UIViewController, Storyboarded {

    private weak var coordinator : MainCoordinator!
    private var interactor : RedditsViewModel!
    private var redditsViewModel: TableViewModel<Reddit, RedditTableViewCell>!
    private lazy var refreshControl = UIRefreshControl()

    @IBOutlet var redditsTable : UITableView!

    //MARK: - lifecycle

    static func fromStoryboard(coordinator : MainCoordinator, interactor: RedditsViewModel) -> RedditsViewController {
        let instance = RedditsViewController.fromStoryboard()
        instance.coordinator = coordinator
        instance.interactor = interactor
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        configurePullToRefresh()

        loadInitialReddits()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        clearTableSelection()
    }

    //MARK: - private

    private func addDismissAllButton() {
        navigationItem.rightBarButtonItem = .init(title: "Dismiss All", style: .plain, target: self, action: #selector(removeAllReddits))
    }

    private func clearTableSelection() {
        if let selected = redditsTable.indexPathForSelectedRow {
            redditsTable.deselectRow(at: selected, animated: true )
        }
    }

    private func configureTable() {
        //TODO: too many handlers, it'd be better to use delegation in this case.
        let onDelete : Handler<[IndexPath]> = { [unowned self] indexPaths in
            self.removeReddits(at: indexPaths)
        }

        let onSelect: Handler<IndexPath> = {[unowned self] indexPath in
            self.openReddit(at: indexPath)
        }

        let onPrefetch: Handler<[IndexPath]> = {[unowned self] indexPaths in
            self.interactor.prefetchReddits(at: indexPaths)
        }

        let onWillReachBottom: Action = {[unowned self] in
            self.loadMoreReddits()
        }

        let isChecked : (Reddit) -> Bool = { [unowned self] reddit in
            self.interactor.isRead(reddit)
        }

        redditsViewModel = TableViewModel(tableView: redditsTable,
                                               isChecked: isChecked,
                                               onDelete: onDelete,
                                               onPrefetch: onPrefetch,
                                               onWillReachBottom:onWillReachBottom,
                                               onSelect: onSelect)
    }

    private func configurePullToRefresh() {
        refreshControl.addTarget(self, action: #selector(reload), for: .valueChanged)
        redditsTable.addSubview(refreshControl)
    }

    private func display(reddits: [Reddit]) {
        redditsViewModel.set(elements:  reddits)
        if !reddits.isEmpty {
            self.addDismissAllButton()
        }
    }

    private func display(newReddits: [Reddit]) {
        redditsViewModel.append(newElements: newReddits)
    }

    private func display(error: Error) {
        presentError(message: error.localizedDescription)
    }

    private func loadInitialReddits() {
        refreshControl.beginRefreshing()
        loadReddits(showIndicator: false) {[weak self] in
            self?.refreshControl.endRefreshing()
        }
    }

    private func loadReddits(showIndicator: Bool = true, onFinished: Action? = nil ) {

        let activityIndicator : UIView? = showIndicator ? self.view.addActivityIndicator() : nil
        interactor.loadReadReddits()
        interactor.loadReddits { [weak self] result in
            activityIndicator?.removeFromSuperview()

            guard let self = self else {return}
            switch result {
            case .failure(let error) :
                onFinished?()
                self.display(error: error)
            case .success(let reddits) :
                onFinished?()
                self.display(reddits: reddits)
            }
        }
    }

    private func loadMoreReddits() {
        interactor.loadMoreReddits { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(let error) :
                self.display(error: error)
            case .success(let reddits) :
                self.display(newReddits: reddits)
            }
        }
    }

    private func markRead(_ reddit: Reddit) {
        interactor.markRead(reddit) { result in
            switch result {
            case .failure(let error):
                display(error: error)
            default: break
            }
        }
    }

    private func openReddit(at indexPath: IndexPath) {
        guard let reddit = self.interactor.reddit(at: indexPath) else {fatalError()}

        markRead(reddit)
        coordinator.openDetails(of: reddit)
        redditsTable.reloadRows(at: [indexPath], with: .none)
    }

    private func removeReddits(at indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            interactor.removeReddit(at: indexPath)
        }
    }

    @objc private func removeAllReddits() {
        interactor.removeAllReddits()
        coordinator.closeDetails()
        display(reddits: [])
        navigationItem.rightBarButtonItem = nil
    }

    @objc private func reload() {
        loadReddits(showIndicator: false) { [weak self] in
            self?.refreshControl.endRefreshing()
        }
    }
}
