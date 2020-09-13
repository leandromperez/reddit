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
    public var stubbingBehavior: StubbingBehavior
    public var baseUrl: String
    public var headers: [String : String]

    public init(stubbingBehavior: StubbingBehavior = .now,
                baseUrl: String = "https://www.reddit.com",
                headers: [String : String] = [:]) {
        self.stubbingBehavior = stubbingBehavior
        self.baseUrl = baseUrl
        self.headers = headers
    }
}

//MARK: - Convenience

public extension RedditAPI {
    func top(limit: Int = 100, after: String? = nil, before: String? = nil) -> Endpoint<Listing> {
        let query = Listing.Query(limit: limit, after: after, before: before)
        return Endpoint<Listing>.get(baseUrl: baseUrl, query: query.stringsDictionary)
    }
}

