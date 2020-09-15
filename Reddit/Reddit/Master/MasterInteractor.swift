//
//  MasterInteractor.swift
//  Reddit
//
//  Created by Leandro Perez on 9/13/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import Foundation
import Reddit_api
import Base
import Endpoints

class MasterInteractor {

    /// It will be called when the interactor gets new information afte performing actions.
    weak var viewController: MasterViewController!

    private let redditAPI: RedditAPI
    private var reddits: [Reddit] = []
    private let stubbing: StubbingBehavior

    //MARK: - lifecycle

    ///
    /// - Parameters:
    ///   - redditAPI: Used to load reddits
    ///   - stubbing: the behavior used to call the endpoints
    internal init(redditAPI: RedditAPI = Current.redditAPI, stubbing: StubbingBehavior = .now) {
        self.redditAPI = redditAPI
        self.stubbing = stubbing
    }

    //MARK: -

    /// Hits the top reddits endpoint and updates the view cotroller when it gets the result
    func loadReddits() {
        redditAPI.topReddits().call(stub: stubbing) {[weak self] (result) in
            guard let self = self else {return}

            switch result {
            case .failure(let error) :
                self.viewController.display(error: error)
            case .success(let listing):
                self.reddits = listing.children
                self.viewController.display(reddits: self.reddits)
            }
        }
    }

    func reddit(at indexPath: IndexPath) -> Reddit? {
        reddits[safe: indexPath.row]
    }
}
