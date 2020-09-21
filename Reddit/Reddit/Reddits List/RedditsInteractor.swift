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

    private let redditAPI: RedditAPI
    private var reddits: [Reddit] = []
    private let imageCache: ImageCache?
    var stubbing: StubbingBehavior

    //MARK: - lifecycle

    ///
    /// - Parameters:
    ///   - redditAPI: Used to load reddits
    ///   - stubbing: the behavior used to call the endpoints
    internal init(redditAPI: RedditAPI = Current.redditAPI,
                  imageCache: ImageCache? = Current.imageCache,
                  stubbing: StubbingBehavior = .now) {
        self.redditAPI = redditAPI
        self.stubbing = stubbing
        self.imageCache = imageCache
    }

    //MARK: - public

    func loadReddits(limit:Int = 50, after lastReddit:Reddit? = nil, onComplete: @escaping Handler<Result<[Reddit], Error>>) {
        redditAPI.topReddits(limit: limit, after: lastReddit?.name)
            .map(\.children)
            .call(stub: stubbing, onComplete: { result in
                if let reddits = try? result.get() {
                    if lastReddit == nil {
                        self.reddits = reddits
                    } else {
                        self.reddits.append(contentsOf: reddits)
                    }
                }
                onComplete(result)
            })
    }

    func prefetchReddits(at indexPaths: [IndexPath]) {
        for each in indexPaths {
            if let url = self.reddits[safe: each.row]?.thumbnailURL {
                self.downloadAndCacheImage(from: url)
            }
        }
    }

    func loadMoreReddits( onComplete: @escaping Handler<Result<[Reddit], Error>>) {
        self.loadReddits(after: reddits.last, onComplete: onComplete)
    }

    func reddit(at indexPath: IndexPath) -> Reddit? {
        reddits[safe: indexPath.row]
    }

    func removeReddit(at index:IndexPath) {
        reddits.remove(at: index.row)
    }

    //MARK: - private

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
