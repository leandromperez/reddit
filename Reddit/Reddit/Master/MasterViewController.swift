//
//  MasterViewController.swift
//  Reddit
//
//  Created by Leandro Perez on 9/13/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import UIKit
import Reddit_api

class MasterViewController: UITableViewController {

    var coordinator : MainCoordinator!
    var interactor : MasterInteractor!

    private var disposeBag = DisposeBag()
    private var elements: [Displayable] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    func setup(coordinator: MainCoordinator, interactor: MasterInteractor) {
        self.coordinator = coordinator
        self.interactor = interactor
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindReddits()
        interactor.loadReddits()
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    private func bindReddits() {
        self.interactor.viewModel
            .map(\.elements).map{$0}
            .assign(to: \.elements, on: self)
            .store(in: &disposeBag)
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.equals(.showDetails),
            let indexPath = tableView.indexPathForSelectedRow, let reddit = interactor.reddit(at: indexPath){
            coordinator.openDetails(of: reddit)
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return elements.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let displayable = elements[indexPath.row] 
        cell.textLabel!.text = displayable.title
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            elements.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}


extension UIStoryboardSegue {
    func equals(_ segue : Segue) -> Bool {
        return self.identifier == segue.rawValue
    }
}


enum Segue : String {
    case showDetails
}
