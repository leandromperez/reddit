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

class TableViewModel<Element: Displayable, Cell: UITableViewCell & DisplayableContainer> : NSObject, UITableViewDataSource, UITableViewDelegate, UITableViewDataSourcePrefetching {

    private var elements : [Element]
    private var onDelete: Handler<[IndexPath]>?
    private var onPrefetch: Handler<[IndexPath]>?
    private var onReachedBottom: Action?
    private var onSelect: Handler<IndexPath>?
    private var tableView : UITableView

    internal init(elements: [Element] = [],
                  tableView: UITableView,
                  onDelete: Handler<[IndexPath]>? = nil,
                  onPrefetch: Handler<[IndexPath]>? = nil,
                  onReachedBottom: Action? = nil,
                  onSelect: Handler<IndexPath>? = nil) {
        self.elements = elements
        self.tableView = tableView
        self.onDelete = onDelete
        self.onPrefetch = onPrefetch
        self.onReachedBottom = onReachedBottom
        self.onSelect = onSelect

        super.init()

        self.setupTableView()
    }

    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        Cell.registerNib(on: tableView)
    }

    func append(newElements: [Element]) {
        let count = self.elements.count
        self.elements.append(contentsOf: newElements)

        let newIndexes = count..<(count + newElements.count)
        let newPaths = newIndexes.map {IndexPath.init(row: $0, section: 0)}
        self.tableView.insertRows(at: newPaths, with: .none)
    }

    func set(elements: [Element]) {
        self.elements = elements
        self.tableView.reloadData()
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
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == self.elements.count - 1 {
            self.onReachedBottom?()
        }
    }

    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onSelect?(indexPath)
    }

    //MARK: - UITableViewDataSourcePrefetching
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        onPrefetch?(indexPaths)
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
