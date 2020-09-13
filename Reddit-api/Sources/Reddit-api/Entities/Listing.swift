
//
//  File.swift
//  
//
//  Created by Leandro Perez on 9/13/20.
//

import Foundation
import Endpoints

public struct Listing : Codable {
    public let children : [RedditThing]
}

extension Listing : EndpointAccessible {
    public typealias Element = Listing
    public static var path: String {
        "/top"
    }
}

