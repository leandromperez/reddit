//
//  File.swift
//  
//
//  Created by Leandro Perez on 9/17/20.
//

import Foundation
import UIKit

public protocol StaticIdentifiable {
    static var identifier : String {get}
}

extension StaticIdentifiable {
    public static var identifier : String {
        return String.init(describing: self)
    }
}

public protocol Bundleable : StaticIdentifiable {
    static func nib(bundle:Bundle?) -> UINib
}

public extension Bundleable {
    static func nib(bundle:Bundle? = nil) -> UINib {
        UINib(nibName: identifier, bundle: bundle)
    }
}
