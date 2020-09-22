//
//  Enrivonment.swift
//  Reddit
//
//  Created by Leandro Perez on 9/13/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import Foundation
import Reddit_api
import Base

var Current = Environment()

/// Environment singleton to control the world. See talk by Stephen Cells https://vimeo.com/291588126
struct Environment {

    var coordinator : MainCoordinator!
    var date : () -> Date
    var imageCache : ImageCache!
    var redditAPI: RedditAPI
    var redditDatabase : RedditDatabase

    internal init(coordinator: MainCoordinator? = MainCoordinator(),
                  date : @escaping () -> Date = Date.init,
                  imageCache : ImageCache = ImageCache(),
                  redditAPI: RedditAPI = RedditAPI(),
                  redditDatabase: RedditDatabase = JsonFile(name: "reddit.database")) {
        self.coordinator = coordinator
        self.imageCache = imageCache
        self.redditAPI = redditAPI
        self.redditDatabase = redditDatabase
        self.date = date
    }
}
