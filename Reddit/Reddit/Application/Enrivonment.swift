//
//  Enrivonment.swift
//  Reddit
//
//  Created by Leandro Perez on 9/13/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import Foundation
import Reddit_api

var Current = Environment()

/// Environment to singleton to control the world. See talk by Stephen Cells https://vimeo.com/291588126
struct Environment {

    var coordinator : MainCoordinator!
    var redditAPI: RedditAPI

    internal init(coordinator: MainCoordinator? = MainCoordinator(),
                  redditAPI: RedditAPI = RedditAPI()) {
        self.coordinator = coordinator
        self.redditAPI = redditAPI
    }
}
