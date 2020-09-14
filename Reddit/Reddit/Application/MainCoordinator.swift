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

class MainCoordinator {
    let environment : Environment
    let splitViewController: UISplitViewController

    init(environment: Environment = Current, splitViewController: UISplitViewController ) {
        self.splitViewController = splitViewController
        self.environment = environment
    }

    var navigationController: UINavigationController {
        splitViewController.viewControllers.last as! UINavigationController
    }

    var detailsViewController: DetailViewController? {
         navigationController.topViewController as? DetailViewController
    }

    func start() {
        navigationController.topViewController?.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        navigationController.topViewController?.navigationItem.leftItemsSupplementBackButton = true
        splitViewController.delegate = self

        let masterNavigator = splitViewController.viewControllers.first as! UINavigationController
        let masterViewController = masterNavigator.topViewController as! MasterViewController

        masterViewController.setup(coordinator: self, interactor: MasterInteractor(redditAPI: environment.redditAPI))
    }

    func openDetails(of reddit:Reddit) {
        let controller = detailsViewController!
        controller.detailItem = NSDate()
        controller.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        controller.navigationItem.leftItemsSupplementBackButton = true
    }
}


extension MainCoordinator : UISplitViewControllerDelegate {

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
}
