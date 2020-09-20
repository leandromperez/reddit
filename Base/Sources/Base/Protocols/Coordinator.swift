//
//  Coordinator.swift
//  
//
//  Created by Leandro Perez on 9/14/20.
//

import Foundation
import UIKit

public protocol Coordinator : AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get }

    func start()
}
