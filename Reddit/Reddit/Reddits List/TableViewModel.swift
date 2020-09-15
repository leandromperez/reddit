//
//  TableViewModel.swift
//  Reddit
//
//  Created by Leandro Perez on 9/13/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import Foundation
import Reddit_api
import Base
import UIKit

class TableViewModel<Element: CellDisplayable> : NSObject, UITableViewDataSource {
    var elements : [Element]
    var onDelete: Handler<[IndexPath]>?

    internal init(elements: [Element] = []) {
        self.elements = elements
    }

    //MARK: - UITableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let displayable = elements[indexPath.row]
        cell.textLabel!.text = displayable.title
        cell.detailTextLabel?.text = displayable.details
        if let url = displayable.thumbnailURL {
            cell.imageView?.loadImageFrom(url: url, placeholder: UIImage(systemName: "photo"))
        }
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

protocol CellDisplayable {
    var subtitle : String {get}
    var thumbnailURL : URL? {get}
    var title: String {get}
    var details : String {get}
}

extension Reddit : CellDisplayable {
    var subtitle: String {
        author
    }

    var thumbnailURL: URL? {
        URL(string: thumbnail)
    }

    var details: String {
        numberOfComments.description
    }
}

