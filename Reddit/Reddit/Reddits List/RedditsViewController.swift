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
    private var interactor : RedditsInteractor!
    private var redditsViewModel: TableViewModel<Reddit, RedditTableViewCell>!

    @IBOutlet var tableView : UITableView!

    //MARK: - lifecycle

    static func fromStoryboard(coordinator : MainCoordinator, interactor: RedditsInteractor) -> RedditsViewController {
        let instance = RedditsViewController.fromStoryboard()
        instance.coordinator = coordinator
        instance.interactor = interactor
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTable()
        loadReddits()
    }


    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        clearTableSelection()
    }

    //MARK: - private
    private func clearTableSelection() {
        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selected, animated: true )
        }
    }

    private func configureTable() {
        let onDelete : Handler<[IndexPath]> = { [unowned self] indexPaths in
            for indexPath in indexPaths {
                self.interactor.removeReddit(at: indexPath)
            }
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

        self.redditsViewModel = TableViewModel(tableView: tableView,
                                               onDelete: onDelete,
                                               onPrefetch: onPrefetch,
                                               onWillReachBottom:onWillReachBottom,
                                               onSelect: onSelect)
    }

    private func display(reddits: [Reddit]) {
        self.redditsViewModel.set(elements:  reddits)
    }

    private func display(newReddits: [Reddit]) {
        self.redditsViewModel.append(newElements: newReddits)
    }

    private func display(error: Error) {
        self.presentError(message: error.localizedDescription)
    }


    private func loadReddits() {
        let activityIndicator = self.view.addActivityIndicator()
        interactor.loadReddits { [weak self] result in
            activityIndicator.removeFromSuperview()

            guard let self = self else {return}
            switch result {
            case .failure(let error) :
                self.display(error: error)
            case .success(let reddits) :
                self.display(reddits: reddits)
            }
        }
    }

    private func loadMoreReddits() {
        self.interactor.loadMoreReddits { [weak self] result in
            guard let self = self else {return}
            switch result {
            case .failure(let error) :
                self.display(error: error)
            case .success(let reddits) :
                self.display(newReddits: reddits)
            }
        }
    }

    private func openReddit(at indexPath: IndexPath) {
        guard let reddit = self.interactor.reddit(at: indexPath) else {fatalError()}
        coordinator.openDetails(of: reddit)
    }
}
