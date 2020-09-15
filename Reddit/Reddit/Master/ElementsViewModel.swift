//
//  MasterViewModel.swift
//  Reddit
//
//  Created by Leandro Perez on 9/13/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import Foundation
import Reddit_api
import Base
import UIKit

class ElementsViewModel<Element: AuthorDisplayable> : NSObject, UITableViewDataSource {
    var elements : [Element]

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
        cell.detailTextLabel?.text = displayable.author
        if let url = URL(string: displayable.thumbnail) {
            cell.imageView?.loadImageFrom(url: url, placeholder: UIImage(systemName: "photo"))
        }
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            elements.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

protocol AuthorDisplayable {
    var author : String {get}
    var thumbnail : String {get}
    var title: String {get}
    var numberOfComments : Int {get}
}

extension Reddit : AuthorDisplayable {}

