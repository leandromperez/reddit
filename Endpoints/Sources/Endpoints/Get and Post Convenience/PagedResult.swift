//
//  File.swift
//  
//
//  Created by Leandro Perez on 4/28/20.
//

import Foundation

public struct PagedResult<T>: Codable where T: Codable {
    public let page: UInt
    public let perPage: UInt
    public let total: UInt
    public let totalPages: UInt
    public let results: [T]

    public enum CodingKeys : String, CodingKey {
        case page, total, results
        case perPage = "per_page"
        case totalPages = "total_pages"
    }
}
