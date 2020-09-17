//
//  File.swift
//  
//
//  Created by Leandro Perez on 9/17/20.
//

import Foundation
import UIKit

extension UITableViewCell : Bundleable {}

extension UITableView {
    public func cell<Cell : UITableViewCell> (at indexPath: IndexPath) -> Cell {
        guard let cell = self.dequeueReusableCell(withIdentifier:Cell.identifier, for: indexPath) as? Cell else {fatalError()}

        return cell
    }
}

extension UITableViewCell  {
    static public func registerNib(on tableView:UITableView, bundle: Bundle? = nil) {
        let nib = self.nib(bundle: bundle)

        tableView.register(nib, forCellReuseIdentifier: self.identifier)
    }

    static public func register(on tableView:UITableView, bundle: Bundle? = nil) {
        tableView.register(Self.self, forCellReuseIdentifier: Self.identifier)
    }
}
