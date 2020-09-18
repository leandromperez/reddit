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

    private lazy var redditsViewController: RedditsViewController = {
        let interactor = RedditsInteractor(redditAPI: Current.redditAPI, stubbing: .never)
        let instance = RedditsViewController.fromStoryboard(coordinator: self, interactor: interactor)
        return instance
    }()

    private lazy var detailsViewController: RedditDetailsViewController = RedditDetailsViewController.fromStoryboard()
    var splitViewController: UISplitViewController = {
        let split = UISplitViewController()
        split.preferredDisplayMode = .allVisible
        return split
    }()
    
//    lazy var splitViewController: SplitViewController = SplitViewController(nibName: nil, bundle: nil)

    init(navigationController: UINavigationController = UINavigationController()) {
        self.navigationController = navigationController
    }

    func start() {
        let masterNavigator = UINavigationController(rootViewController: redditsViewController)
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


//class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {
//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        self.delegate = self
//        self.preferredDisplayMode = .allVisible
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        self.delegate = self
//        self.preferredDisplayMode = .allVisible
//    }
//
//    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
//        return true
//    }
//}


extension MainCoordinator : UISplitViewControllerDelegate {

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        return true
//        guard let secondaryAsNavController = secondaryViewController as? UINavigationController else { return false }
//        guard let topAsDetailController = secondaryAsNavController.topViewController as? RedditDetailsViewController else { return false }
//        if topAsDetailController.detailItem == nil {
//            // Return true to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
//            return true
//        }
//        return false
    }
}
