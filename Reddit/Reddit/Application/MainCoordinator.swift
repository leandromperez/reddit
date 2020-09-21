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

    private lazy var redditsViewController: RedditsViewController = {
        let interactor = RedditsInteractor(redditAPI: Current.redditAPI, stubbing: .never)
        let instance = RedditsViewController.fromStoryboard(coordinator: self, interactor: interactor)
        return instance
    }()

    //MARK: - lifecycle

    var navigationController: UINavigationController {
        splitViewController.viewControllers.last as! UINavigationController
    }

    //MARK: - actions

    func start() {

        let masterNavigator = splitViewController.viewControllers.first as! UINavigationController
        masterNavigator.viewControllers = [redditsViewController]
        splitViewController.preferredDisplayMode = .allVisible
        splitViewController.delegate = self

        //Push details vc, so it's opened with no reddit, and it causes master to toggle (on ipad, portrait mod)
        pushDetailsViewController()

        splitViewController.toggleMaster()
    }

    func openDetails(of reddit:Reddit) {
        let details = detailsViewController ?? pushDetailsViewController()
        details.reddit = reddit
    }

    //MARK: - private

    @discardableResult
    private func pushDetailsViewController() -> RedditDetailsViewController {
        let newDetails = RedditDetailsViewController.fromStoryboard()
        newDetails.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        newDetails.navigationItem.leftItemsSupplementBackButton = true
        self.navigationController.pushViewController(newDetails, animated: true)
        return newDetails
    }

    private var detailsNavigator: UINavigationController {
        splitViewController.viewControllers.last as! UINavigationController
    }

    private var detailsViewController: RedditDetailsViewController? {
        guard let secondaryAsNavController = self.splitViewController.viewControllers.last as? UINavigationController else { return nil }
        return secondaryAsNavController.topViewController as? RedditDetailsViewController
    }

}

extension MainCoordinator : UISplitViewControllerDelegate {

    // MARK: - Split view

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController:UIViewController, onto primaryViewController:UIViewController) -> Bool {
        if detailsViewController?.reddit == nil {
            return true
        }
        return false
    }
}


extension UIView {
    func addActivityIndicator() -> UIView {
        let container: UIView = UIView()
        container.frame = self.frame
        container.center = self.center
        container.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.addSubview(container)

        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = self.center
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        container.addSubview(loadingView)

        let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
        indicator.frame = CGRect(x:0, y:0, width:40, height:40);
        indicator.style = .large
        indicator.center = CGPoint(x:loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);
        loadingView.addSubview(indicator)

        indicator.startAnimating()
        
        return container
    }
}
