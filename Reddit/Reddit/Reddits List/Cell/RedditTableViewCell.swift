//
//  RedditsTableViewCell.swift
//  Reddit
//
//  Created by Leandro Perez on 9/17/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import UIKit
import Base

class RedditTableViewCell: UITableViewCell, DisplayableContainer {

    @IBOutlet var detailsLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var thumbnail: UIImageView!

    var displayable: Displayable? {
        didSet {
            self.updateView()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.displayable = nil
    }

    private func updateView() {
        self.titleLabel.text = displayable?.title
        self.subtitleLabel.text = displayable?.subtitle
        self.detailsLabel.text = displayable?.details

        displayable?.loadThumbnail(on: thumbnail)
    }
}

extension Displayable {
    func loadThumbnail(on imageView : UIImageView) {
        if let url = self.thumbnailURL {
            imageView.downloadloadImageFrom(url: url, cache: Current.imageCache)
        } else {
            imageView.image = UIImage(systemName: "photo")
        }
    }
}
