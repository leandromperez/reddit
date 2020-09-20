//
//  MainCoordinator.swift
//  Reddit
//
//  Created by Leandro Perez on 9/13/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import Foundation
import UIKit
import Base
import Reddit_api

class MainCoordinator : Coordinator {
    var childCoordinators: [Coordinator] = []
    var splitViewController: UISplitViewController!

    var navigationController: UINavigationController {
        splitViewController.viewControllers.first as! UINavigationController
    }

    private lazy var redditsViewController: RedditsViewController = {
        let interactor = RedditsInteractor(redditAPI: Current.redditAPI, stubbing: .never)
        let instance = RedditsViewController.fromStoryboard(coordinator: self, interactor: interactor)
        return instance
    }()

    private lazy var detailsViewController: RedditDetailsViewController = RedditDetailsViewController.fromStoryboard()

    func start() {

        let masterNavigator = splitViewController.viewControllers.first as! UINavigationController
        let detailsNavigator = splitViewController.viewControllers.last as! UINavigationController
        masterNavigator.viewControllers = [redditsViewController]
        detailsNavigator.viewControllers = [detailsViewController]

        detailsViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        detailsViewController.navigationItem.leftItemsSupplementBackButton = true

        splitViewController.delegate = self
    }

    func openDetails(of reddit:Reddit) {
        let details = detailsViewController
        details.detailItem = NSDate()
        details.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        details.navigationItem.leftItemsSupplementBackButton = true
    }

    private var detailsNavigator: UINavigationController {
        splitViewController.viewControllers.last as! UINavigationController
    }


}

extension MainCoordinator : UISplitViewControllerDelegate {

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? RedditDetailsViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
}
