//
//  File.swift
//  
//
//  Created by Leandro Perez on 9/13/20.
//

import Foundation

public extension Listing {
    struct Query : Codable {
        var limit: Int
        var after: String?
        var before: String?

        var stringsDictionary: [String: String] {
            self.toStringsDictionary() ?? [:]
        }
    }
}
