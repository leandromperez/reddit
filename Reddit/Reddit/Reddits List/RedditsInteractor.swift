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
import UIKit

class RedditsInteractor {

    weak var presenter: RedditsPresenter!

    private let redditAPI: RedditAPI
    private var reddits: [Reddit] = []
    private let imageCache: ImageCache?
    private let stubbing: StubbingBehavior

    //MARK: - lifecycle

    ///
    /// - Parameters:
    ///   - redditAPI: Used to load reddits
    ///   - stubbing: the behavior used to call the endpoints
    internal init(redditAPI: RedditAPI = Current.redditAPI,
                  imageCache: ImageCache? = Current.imageCache,
                  stubbing: StubbingBehavior = .now,
                  presenter: RedditsPresenter? = nil) {
        self.redditAPI = redditAPI
        self.stubbing = stubbing
        self.presenter = presenter
        self.imageCache = imageCache
    }

    //MARK: - public

    /// Hits the top reddits endpoint and updates the view cotroller when it gets the result
    func loadReddits() {
        loadReddits() {[weak self] (newReddits) in
            guard let self = self else {return}
            self.reddits = newReddits
            self.presenter.display(reddits: newReddits)
        }
    }

    func prefetchReddits(at indexPaths: [IndexPath]) {
        for each in indexPaths {
            if let url = self.reddits[safe: each.row]?.thumbnailURL {
                self.downloadAndCacheImage(from: url)
            }
        }
    }

    func loadMoreReddits() {
        loadReddits(after: reddits.last) {[weak self] (newReddits) in
            guard let self = self else {return}
            self.reddits.append(contentsOf: newReddits)
            self.presenter.display(newReddits: newReddits)
        }
    }

    func reddit(at indexPath: IndexPath) -> Reddit? {
        reddits[safe: indexPath.row]
    }

    func removeReddit(at index:IndexPath) {
        reddits.remove(at: index.row)
    }

    //MARK: - private

    private func loadReddits(after lastReddit: Reddit? = nil, onSuccess: @escaping Handler<[Reddit]>) {
        redditAPI.topReddits(limit: 50, after: lastReddit?.name).call(stub: stubbing) {[weak self] (result) in
            guard let self = self else {return}

            switch result {
            case .failure(let error) :
                self.presenter.display(error: error)
            case .success(let listing):
                onSuccess(listing.children)
            }
        }
    }

    private func downloadAndCacheImage(from url: URL) {
        if imageCache != nil && imageCache?[url.absoluteString] == nil {
            Endpoint<UIImage>(imageURL: url).call(dispatchQueue:.global()) {[weak self] (result) in
                if let image = try? result.get() {
                    self?.imageCache?[url.absoluteString] = image
                }
            }
        }
    }
}
