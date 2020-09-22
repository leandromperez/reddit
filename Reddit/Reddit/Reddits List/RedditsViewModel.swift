//
//  RedditsViewModel.swift
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

class RedditsViewModel {

    private let redditAPI: RedditAPI
    private let redditDatabase: RedditDatabase
    private var reddits: [Reddit] = []
    private var readReddits: [Reddit] = []
    private let imageCache: ImageCache?
    var stubbing: StubbingBehavior

    //MARK: - lifecycle

    ///
    /// - Parameters:
    ///   - redditAPI: Used to load reddits
    ///   - stubbing: the behavior used to call the endpoints
    internal init(redditAPI: RedditAPI = Current.redditAPI,
                  redditDatabase : RedditDatabase = Current.redditDatabase,
                  imageCache: ImageCache? = Current.imageCache,
                  stubbing: StubbingBehavior = .now) {
        self.redditAPI = redditAPI
        self.stubbing = stubbing
        self.imageCache = imageCache
        self.redditDatabase = redditDatabase
    }

    //MARK: - public

    func loadReadReddits(onComplete: Handler<Result<[Reddit], Error>>? = nil) {
        do {
            self.readReddits = try redditDatabase.loadReadReddits()
            onComplete?(.success(readReddits))
        } catch let error {
            onComplete?(.failure(error))
        }
    }

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

    func removeAllReddits() {
        reddits.removeAll()
    }

    func markRead(_ reddit: Reddit, onComplete: Handler<Result<Void, Error>> ) {
        self.readReddits.append(reddit)
        do {
            try self.redditDatabase.saveReadReddits(reddits: Array(self.readReddits))
            onComplete(.success(()))
        } catch let error{
            onComplete(.failure(error))
        }
    }

    func isRead(_ reddit: Reddit) -> Bool {
        readReddits.contains(reddit)
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
