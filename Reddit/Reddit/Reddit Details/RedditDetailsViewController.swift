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
    @IBOutlet var addToLibraryButton: UIButton!

    var reddit: Displayable? {
        didSet {
            updateView()
        }
    }

    //MARK: - lifecycle

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

    //MARK: - actions

    @IBAction func saveImage() {
        guard let image = picture.image else { return }
        ImageSaver().save(image: image) { result in
            switch result {
            case .failure:
                self.presentError(message: "Unable to save the image")
            case .success:
                self.presentAlert(title: "Success", message: "Image saved!")
            }
        }
    }
    
    //MARK: - private

    private func updateView() {
        if let reddit = reddit, self.isViewLoaded {
            titleLabel.text = reddit.title
            subtitleLabel.text = reddit.subtitle
            detailsLabel.text = reddit.details

            reddit.loadThumbnail(on: picture)
        }
    }
}
