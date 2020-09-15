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
    func loadImageFrom( url: URL,
                        placeholder: UIImage? = nil,
                        onCompletion: Handler<Result<UIImage, Error>>? = nil) {
        self.image = placeholder
        Endpoint<UIImage>(imageURL: url).call {[weak self] (result) in
            onCompletion?(result)
            DispatchQueue.main.async {
                self?.image =  try? result.get()
            }
        }
    }
}
