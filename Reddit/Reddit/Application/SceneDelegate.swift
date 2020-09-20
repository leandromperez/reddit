//
//  SceneDelegate.swift
//  Example
//
//  Created by Leandro Perez on 9/20/20.
//  Copyright © 2020 Muuv Labs. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let window = window else { fatalError()}
        guard let splitViewController = window.rootViewController as? UISplitViewController else { fatalError() }
        guard let mainCoordinator = Current.coordinator else {fatalError()}

        mainCoordinator.splitViewController = splitViewController
        mainCoordinator.start()
    }
}

