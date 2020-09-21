//
//  File.swift
//  
//
//  Created by Leandro Perez on 9/20/20.
//

import Foundation
import UIKit

public extension UISplitViewController {
    func toggleMaster() {
        let barButtonItem = self.displayModeButtonItem
        UIApplication.shared.sendAction(barButtonItem.action!, to: barButtonItem.target, from: nil, for: nil)
    }
}
