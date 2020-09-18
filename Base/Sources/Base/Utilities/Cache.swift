//
//  File.swift
//  
//
//  Created by Leandro Perez on 9/17/20.
//

import Foundation
import UIKit

public class Cache<Element: NSObject> {
    private let cache = NSCache<NSString, Element>()

    public init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(clear),
                                               name: UIApplication.didReceiveMemoryWarningNotification,
                                               object: nil)
    }

    @objc public func clear() {
        cache.removeAllObjects()
    }

    public subscript (key: String) -> Element? {
        get {
            return cache.object(forKey: NSString(string: key))
        }
        set {
            let key = NSString(string: key)
            if let newElement = newValue {
                cache.setObject(newElement, forKey: key)
            } else {
                cache.removeObject(forKey: key)
            }
        }
    }
}

public typealias ImageCache = Cache<UIImage>
