//
//  File.swift
//  
//
//  Created by Leandro Perez on 9/13/20.
//

import Foundation
import Endpoints

public typealias ReddditListing = Listing<Reddit>

extension Listing : EndpointAccessible where T == Reddit {
    public typealias Element = Listing
    public static var path: String {
        "/top.json"
    }
}

