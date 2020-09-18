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

    private let onDelete: Handler<[IndexPath]>?
    private let onPrefetch: Handler<[IndexPath]>?
    private let onWillReachBottom: Action?
    private let onSelect: Handler<IndexPath>?
    private let tableView : UITableView
    private let willReachBottomOffset :Int

    /// Creates a table view model
    /// - Parameters:
    ///   - elements: elements that will be displayed in the table
    ///   - tableView: the table
    ///   - willReachBottomOffset: -10 by default. when reaching `elements.count + willReachBottomOffset` it will notify that it's reaching the end of the table
    ///   - onDelete: callback for deletion
    ///   - onPrefetch: callback for prefetching
    ///   - onWillReachBottom: called when the table is about to reach the bottom, it uses the `willReachBottomOffset` parameter
    ///   - onSelect: callback for cell selection
    internal init(elements: [Element] = [],
                  tableView: UITableView,
                  willReachBottomOffset : Int = -10,
                  onDelete: Handler<[IndexPath]>? = nil,
                  onPrefetch: Handler<[IndexPath]>? = nil,
                  onWillReachBottom: Action? = nil,
                  onSelect: Handler<IndexPath>? = nil) {
        self.elements = elements
        self.tableView = tableView
        self.onDelete = onDelete
        self.onPrefetch = onPrefetch
        self.onWillReachBottom = onWillReachBottom
        self.onSelect = onSelect
        self.willReachBottomOffset = willReachBottomOffset
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
        if indexPath.row == self.elements.count + willReachBottomOffset {
            self.onWillReachBottom?()
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
