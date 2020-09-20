//
//  File.swift
//
//
//  Created by Leandro Perez on 9/14/20.
//

import Foundation
import UIKit
import Base

public extension UIImageView {

    /// Loads an `UIImage` from a remote url and sets it as the receiver's image.
    /// - Parameters:
    ///   - url: the url that contains the jpeg,
    ///   - placeholder: this image will be set until the new one is available
    ///   - onCompletion: `nil` by default
    func downloadloadImageFrom( url: URL,
                                cache: ImageCache? = nil,
                                placeholder: UIImage? = nil,
                                onCompletion: Handler<Result<UIImage, Error>>? = nil) {

        //TODO: find what's wrong
//        if let cached = cache?[url.absoluteString] {
//            onCompletion?(.success(cached))
//            print("cached!!! \(url)")
//            return
//        }

        self.image = placeholder
        Endpoint<UIImage>(imageURL: url).call {[weak self] (result) in

            DispatchQueue.main.async {
                let downloaded = try? result.get()
                self?.image = downloaded
                cache?[url.absoluteString] = downloaded
                onCompletion?(result)
            }
        }
    }
}

