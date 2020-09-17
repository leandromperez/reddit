//
//  TableViewModel.swift
//  Reddit
//
//  Created by Leandro Perez on 9/13/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import Foundation
import Base
import UIKit

class TableViewModel<Element: Displayable, Cell: UITableViewCell & DisplayableContainer> : NSObject, UITableViewDataSource {
    var elements : [Element]
    var onDelete: Handler<[IndexPath]>?

    internal init(elements: [Element] = []) {
        self.elements = elements
    }

    func setup(tableView: UITableView ) {
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        Cell.registerNib(on: tableView)
    }

    //MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : Cell = tableView.cell(at: indexPath)
        cell.displayable = elements[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            elements.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            onDelete?([indexPath])
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

protocol DisplayableContainer {
    var displayable: Displayable? {get set}
}

protocol Displayable {
    var subtitle : String {get}
    var thumbnailURL : URL? {get}
    var title: String {get}
    var details : String {get}
}
