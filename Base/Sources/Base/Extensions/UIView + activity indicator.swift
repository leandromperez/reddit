//
//  File.swift
//  
//
//  Created by Leandro Perez on 9/20/20.
//

import Foundation
import UIKit

public extension UIView {
    func addActivityIndicator() -> UIView {
        let container: UIView = UIView()
        container.frame = self.frame
        container.center = self.center
        container.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        self.addSubview(container)

        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        loadingView.center = self.center
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        container.addSubview(loadingView)

        let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
        indicator.frame = CGRect(x:0, y:0, width:40, height:40);
        if #available(iOS 13.0, *) {
            indicator.style = .large
        } else {
            indicator.style = .white    
        }
        indicator.color = .white
        indicator.center = CGPoint(x:loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2);
        loadingView.addSubview(indicator)

        indicator.startAnimating()

        return container
    }
}
