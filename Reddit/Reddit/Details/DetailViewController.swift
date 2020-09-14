//
//  DetailViewController.swift
//  Reddit
//
//  Created by Leandro Perez on 9/13/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import UIKit
import Base

class DetailViewController: UIViewController, Storyboarded {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureView()
    }

    var detailItem: NSDate? {
        didSet {
            // Update the view.
            configureView()
        }
    }

    private func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            detailDescriptionLabel.text = detail.description
        }
    }
}

