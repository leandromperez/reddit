//
//  Storyboard.swift
//  Futures App Framework
//
//  Created by Leandro Perez on 7/7/19.
//  Copyright © 2019 Leandro Perez. All rights reserved.
//

import Foundation
import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(bundle: Bundle = .main) -> Self {
        guard let className = NSStringFromClass(self).components(separatedBy: ".").last else { fatalError() }
        return UIStoryboard(name: className, bundle: bundle).instantiateViewController(withIdentifier: className) as! Self
    }
}
