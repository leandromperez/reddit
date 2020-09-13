//
//  File.swift
//
//
//  Created by Leandro Perez on 9/13/20.
//

import Foundation
import Endpoints
import Base

public struct RedditAPI : Backend {
    public static var baseUrl: String =  "https://www.reddit.com"
    public var stubbingBehavior: StubbingBehavior
    public var baseUrl: String
    public var headers: [String : String]

    public init(stubbingBehavior: StubbingBehavior = .now,
                baseUrl: String = RedditAPI.baseUrl,
                headers: [String : String] = [:]) {
        self.stubbingBehavior = stubbingBehavior
        self.baseUrl = baseUrl
        self.headers = headers
    }
}

//MARK: - Convenience

public extension RedditAPI {

    /// Creates an endpoint to the `top` listing endpoint explained here: https://www.reddit.com/dev/api#GET_top
    /// - Parameters:
    ///   - limit: the maximum number of items desired (default: 25, maximum: 100)
    ///   - after: fullname of a thing
    ///   - before: fullname of a thing
    /// - Returns: an endpoint instance connected to http://www.reddit.com/top.json, e.g. https://www.reddit.com/top.json?limit=10&after=t3_irj36w
    func topReddits(limit: Int = 100, after: String? = nil, before: String? = nil) -> Endpoint<ReddditListing> {
        let query = ReddditListing.Query(limit: limit, after: after, before: before)
    
        return Endpoint<ReddditListing>.get(baseUrl: baseUrl,
                                     query: query.stringsDictionary)
    }
}

