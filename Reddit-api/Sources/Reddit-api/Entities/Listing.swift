
//
//  File.swift
//  
//
//  Created by Leandro Perez on 9/13/20.
//

import Foundation
import Endpoints

public struct Listing<T: Codable> : Codable {
    private struct Data : Codable {
        let after : String?
        let before: String?
        let children: [T]
    }

    private let data: Data

    public var children : [T] {
        data.children
    }
}



extension Listing : EndpointAccessible where T == Reddit {
    public typealias Element = Listing
    public static var path: String {
        "/top.json"
    }
}

