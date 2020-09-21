//
//  RedditsDatabase.swift
//  Reddit
//
//  Created by Leandro Perez on 9/21/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import Foundation
import Reddit_api
import Base

protocol RedditDatabase {
    func loadReadReddits() throws -> [Reddit]
    func saveReadReddits(reddits:[Reddit]) throws
}

extension JsonFile : RedditDatabase {
    func loadReadReddits() throws -> [Reddit] {
        return try self.loadList()
    }

    func saveReadReddits(reddits:[Reddit]) throws{
        try self.save(element: reddits)
    }
}
