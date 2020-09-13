//
//  File.swift
//  
//
//  Created by Leandro Perez on 5/1/20.
//

import Foundation

public protocol Backend {
    var stubbingBehavior : StubbingBehavior {get}
    var baseUrl : String {get}
    var headers: [String : String] {get}
}

public struct StubbedBackend: Backend {
    public init(){}
    
    public var stubbingBehavior: StubbingBehavior {
        .after(time: .milliseconds(400))
    }

    public var baseUrl: String {
        "localhost://backend"
    }

    public var headers: [String : String] {
        [:]
    }
}
