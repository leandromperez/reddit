//
//  RedditsTableViewCell.swift
//  Reddit
//
//  Created by Leandro Perez on 9/17/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import UIKit

class RedditTableViewCell: UITableViewCell, DisplayableContainer {

    @IBOutlet var detailsLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var thumbnail: UIImageView!

    var displayable: Displayable? {
        didSet {
            self.update()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.displayable = nil
    }

    private func update() {
        self.titleLabel.text = displayable?.title
        self.subtitleLabel.text = displayable?.subtitle
        self.detailsLabel.text = displayable?.details

        if let url = displayable?.thumbnailURL {
            self.thumbnail.downloadloadImageFrom(url: url, cache: Current.imageCache)
        } else {
            self.thumbnail.image = UIImage(systemName: "photo")
        }
    }
}
