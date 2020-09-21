//
//  File.swift
//  
//
//  Created by Leandro Perez on 9/21/20.
//

import Foundation

public struct JsonFile {
    public struct IOError : Error{}

    public let name: String

    public init(name: String) {
        self.name = name
    }
    
    public func load<T:Codable>() throws -> T? {
        let url = try fileUrl()
        let jsonData = try Data(contentsOf: url)

        let decoder = JSONDecoder()
        let element = try decoder.decode(T.self, from: jsonData)

        return element
    }

    public func loadList<T:Codable>() throws -> [T] {
        return try load() ?? []
    }

    public func fileUrl() throws -> URL {
        do {
            let docDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            return docDir.appendingPathComponent(name + ".json")
        } catch {
            throw IOError()
        }
    }

    public func save<T:Codable>(element:T) throws {
        let encoder = JSONEncoder()

        let url = try fileUrl()
        let data = try encoder.encode(element)
        try data.write(to: url)
    }

    public func removeFile() throws {
        let url = try fileUrl()
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            throw IOError()
        }
    }
}
