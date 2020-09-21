//
//  File.swift
//  
//
//  Created by Leandro Perez on 9/21/20.
//

import Foundation
import UIKit

public class ImageSaver: NSObject {
    private var handler : Handler<Result<UIImage, Error>>? = nil

    public func save(image: UIImage, onComplete: Handler<Result<UIImage, Error>>? = nil) {
        self.handler = onComplete
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(onSaved), nil)
    }

    @objc func onSaved(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            handler?(.failure(error))
        } else {
            handler?(.success(image))
        }
    }
}
