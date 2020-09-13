//
//  Storyboard.swift
//  Futures App Framework
//
//  Created by Leandro Perez on 7/7/19.
//  Copyright © 2019 Leandro Perez. All rights reserved.
//

import Foundation

public protocol Storyboard {
    func initialViewController<T : ViewController> () -> T
    var name : String {get}
    var bundle : Bundle {get}
}

public extension Storyboard {
    var storyboard : StoryboardType {
        return StoryboardType.init(name: self.name, bundle: self.bundle)
    }

    func initialViewController<T : ViewController> () -> T {

        guard let vc : T = self.storyboard.instantiateInitialViewController() as? T else {fatalError()}

        return vc
    }
}

extension Storyboard where Self : RawRepresentable, Self.RawValue == String {
    public var name : String {
        return self.rawValue.capitalizingFirstLetter()
    }
}

extension StoryboardType {
    func instantiateInitialViewController<T:ViewController>() -> T? {

        #if os(macOS)
        guard let vc : T = self.instantiateInitialController() as? T else {fatalError()}
        return vc
        #elseif canImport(UIKit)
        guard let vc : T = self.instantiateInitialViewController() as? T else {fatalError()}
        return vc
        #endif
    }
}
