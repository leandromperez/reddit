//
//  DetailViewController.swift
//  Reddit
//
//  Created by Leandro Perez on 9/13/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import UIKit
import Base

class RedditDetailsViewController: UIViewController, Storyboarded {

    @IBOutlet var detailsLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var picture: UIImageView!

    var reddit: Displayable? {
        didSet {
            updateView()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if reddit == nil {
            self.splitViewController?.toggleMaster()
        }
    }

    private func updateView() {
        if let reddit = reddit, self.isViewLoaded {
            titleLabel.text = reddit.title
            subtitleLabel.text = reddit.subtitle
            detailsLabel.text = reddit.details

            reddit.loadThumbnail(on: picture)
        }
    }
}


extension UISplitViewController {
    func toggleMaster() {
        let barButtonItem = self.displayModeButtonItem
        UIApplication.shared.sendAction(barButtonItem.action!, to: barButtonItem.target, from: nil, for: nil)
    }
}
