
//
//  File.swift
//  
//
//  Created by Leandro Perez on 9/13/20.
//

import Foundation
import Endpoints

public struct Listing : Codable {
    private struct Data : Codable {
        let after : String?
        let before: String?
        let children: [RedditThing]
    }

    private let data: Data

    public var children : [RedditThing] {
        data.children
    }
}

extension Listing : EndpointAccessible {
    public typealias Element = Listing
    public static var path: String {
        "/top.json"
    }
}

