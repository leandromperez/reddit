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
    var navigationController: UINavigationController

    private lazy var masterViewController: MasterViewController = MasterViewController.fromStoryboard(coordinator: self, interactor: MasterInteractor())
    private lazy var detailsViewController: DetailViewController = DetailViewController.fromStoryboard()

    lazy var splitViewController: UISplitViewController = UISplitViewController()

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    func start() {
        let masterNavigator = UINavigationController(rootViewController: masterViewController)
        let detailsNavigator = UINavigationController(rootViewController: detailsViewController)

        masterNavigator.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        masterNavigator.navigationItem.leftItemsSupplementBackButton = true
        splitViewController.delegate = self

        splitViewController.viewControllers = [masterNavigator, detailsNavigator]
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
        guard let topAsDetailController = secondaryAsNavController.topViewController as? DetailViewController else { return false }
        if topAsDetailController.detailItem == nil {
            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
            return true
        }
        return false
    }
}
