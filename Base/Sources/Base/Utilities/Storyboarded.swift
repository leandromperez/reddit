//
//  Storyboard.swift
//  Futures App Framework
//
//  Created by Leandro Perez on 7/7/19.
//  Copyright © 2019 Leandro Perez. All rights reserved.
//

import Foundation
import UIKit

//Approach taken from https://www.hackingwithswift.com/articles/71/how-to-use-the-coordinator-pattern-in-ios-apps

public protocol Storyboarded {
    static func fromStoryboard(bundle: Bundle) -> Self
}

extension Storyboarded where Self: UIViewController {
    public static func fromStoryboard(bundle: Bundle = .main) -> Self {
        guard let className = NSStringFromClass(self).components(separatedBy: ".").last else { fatalError() }
        let storyboard = UIStoryboard(name: className, bundle: bundle)
        if let vc = storyboard.instantiateInitialViewController() as? Self {
            return vc
        }
        return storyboard.instantiateViewController(withIdentifier: className) as! Self

    }
}
