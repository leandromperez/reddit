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
    private var redditsViewModel: TableViewModel<Reddit>!

    @IBOutlet weak var tableView : UITableView!

    //MARK: - lifecycle

    static func fromStoryboard(coordinator : MainCoordinator, interactor: RedditsInteractor) -> RedditsViewController {
        let instance = RedditsViewController.fromStoryboard()
        instance.coordinator = coordinator
        instance.interactor = interactor
        instance.redditsViewModel = TableViewModel()
        interactor.presenter = instance
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTable()
        interactor.loadReddits()
    }

    //MARK: - actions

    private func openReddit(at indexPath: IndexPath) {
        guard let reddit = self.interactor.reddit(at: indexPath) else {fatalError()}
        coordinator.openDetails(of: reddit)
    }

    //MARK: - actions

    private func configureTable() {
        tableView.delegate = self
        tableView.dataSource = self.redditsViewModel

        self.redditsViewModel.onDelete = { [unowned self] indexPaths in
            for indexPath in indexPaths {
                self.interactor.removeReddit(at: indexPath)
            }
        }
    }

}


extension RedditsViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openReddit(at: indexPath)
    }
}

extension RedditsViewController : RedditsPresenter {

    func display(reddits: [Reddit]) {
        self.redditsViewModel.elements = reddits
        self.tableView.reloadData()
    }

    func display(error: Error) {
        self.presentError(message: error.localizedDescription)
    }
}
