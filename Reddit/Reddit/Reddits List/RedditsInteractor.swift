//
//  RedditsInteractor.swift
//  Reddit
//
//  Created by Leandro Perez on 9/13/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import Foundation
import Reddit_api
import Base
import Endpoints

class RedditsInteractor {

    weak var presenter: RedditsPresenter!

    private let redditAPI: RedditAPI
    private var reddits: [Reddit] = []
    private let stubbing: StubbingBehavior

    //MARK: - lifecycle

    ///
    /// - Parameters:
    ///   - redditAPI: Used to load reddits
    ///   - stubbing: the behavior used to call the endpoints
    internal init(redditAPI: RedditAPI = Current.redditAPI,
                  stubbing: StubbingBehavior = .now,
                  presenter: RedditsPresenter? = nil) {
        self.redditAPI = redditAPI
        self.stubbing = stubbing
        self.presenter = presenter
    }

    //MARK: -

    /// Hits the top reddits endpoint and updates the view cotroller when it gets the result
    func loadReddits() {
        print(stubbing)
        redditAPI.topReddits().call(stub: stubbing) {[weak self] (result) in
            guard let self = self else {return}

            switch result {
            case .failure(let error) :
                self.presenter.display(error: error)
            case .success(let listing):
                self.reddits = listing.children
                self.presenter.display(reddits: self.reddits)
            }
        }
    }

    func loadReddits(at: [IndexPath]) {
        
    }


    func reddit(at indexPath: IndexPath) -> Reddit? {
        reddits[safe: indexPath.row]
    }


    func removeReddit(at index:IndexPath) {

    }
    
}

