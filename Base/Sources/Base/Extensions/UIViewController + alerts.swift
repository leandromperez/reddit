//
//  File.swift
//  
//
//  Created by Leandro Perez on 9/14/20.
//

import Foundation
import UIKit

public extension UIViewController {

    func presentAlert(animated: Bool = true,
                      title: String,
                      message : String,
                      okTitle: String = "Ok",
                      okHandler: Action? = nil,
                      completionHandler: Action? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let ok = UIAlertAction(title: okTitle, style: .default) { _ in
            okHandler?()
        }

        alertController.addAction(ok)
        self.present(alertController, animated: animated, completion: completionHandler)
    }

    func presentError(animated: Bool = true,
                      title: String = "Error",
                      message : String,
                      okTitle: String = "Ok",
                      okHandler: Action? = nil,
                      completionHandler: Action? = nil) {
        self.presentAlert(animated: animated, title: title, message: message, okTitle: okTitle, okHandler: okHandler, completionHandler: completionHandler)
    }

}

