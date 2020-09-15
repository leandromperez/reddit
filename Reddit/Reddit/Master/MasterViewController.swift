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

class MasterViewController: UIViewController, Storyboarded {

    private weak var coordinator : MainCoordinator!
    private var interactor : MasterInteractor!
    private var redditsViewModel: ElementsViewModel<Reddit>!

    @IBOutlet weak var tableView : UITableView!

    //MARK: - lifecycle

    static func fromStoryboard(coordinator : MainCoordinator, interactor: MasterInteractor) -> MasterViewController {
        let instance = MasterViewController.fromStoryboard()
        instance.coordinator = coordinator
        instance.interactor = interactor
        instance.redditsViewModel = ElementsViewModel()
        interactor.viewController = instance
        return instance
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self.redditsViewModel

        interactor.loadReddits()
    }

    //MARK: - updating UI

    func display(reddits: [Reddit]) {
        self.redditsViewModel.elements = reddits
        self.tableView.reloadData()
    }

    func display(error: Error) {
        self.presentError(message: error.localizedDescription)
    }

    //MARK: - actions

    private func openReddit(at indexPath: IndexPath) {
        guard let reddit = self.interactor.reddit(at: indexPath) else {fatalError()}
        self.coordinator.openDetails(of: reddit)
    }
}


extension MasterViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        openReddit(at: indexPath)
    }
}
