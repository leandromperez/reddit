//
//  File.swift
//  
//
//  Created by Leandro Perez on 9/13/20.
//

import Foundation

public struct RedditThing : Codable {
    private let data : Data
    public let kind : String
    
    public var author: String {
        data.author
    }

    public var creationDate: Double {
        data.creationDate
    }

    public var numComments: Int {
        data.numComments
    }

    public var thumbnail: String {
        data.thumbnail
    }

    public var title: String {
        data.title
    }

    public var url: String {
        data.url
    }

    private struct Data : Codable {
        let title: String
        let author: String
        let creationDate: Double
        let thumbnail: String
        let url: String
        let numComments: Int
    }
}
