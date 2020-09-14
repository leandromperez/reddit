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

struct Environment {

    var coordinator : MainCoordinator!
    var redditAPI: RedditAPI

    internal init(coordinator: MainCoordinator? = nil,
                  redditAPI: RedditAPI = RedditAPI()) {
        self.coordinator = coordinator
        self.redditAPI = redditAPI
    }
}
