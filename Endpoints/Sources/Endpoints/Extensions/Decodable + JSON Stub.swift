//
//  File.swift
//  
//
//  Created by Leandro Perez on 5/1/20.
//

import Foundation

struct MissingStubFile : Error {
    let name: String

}
extension MissingStubFile : CustomDebugStringConvertible {
    var debugDescription: String {
        "Missing Stub File: \(name)"
    }
}

public extension Decodable {
    static var stubJsonFilename : String {
        "stub-\(Self.self)"
    }

    static func fromStubJson(fileName: String? = nil, bundle: Bundle = .main) throws -> Self {
        let jsonFileName = fileName ?? Self.stubJsonFilename
        guard let path = bundle.path(forResource: jsonFileName, ofType: "json") else { throw MissingStubFile(name:jsonFileName)}

        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let decoded = try JSONDecoder().decode(Self.self, from: data)
        return decoded
    }
    
}
