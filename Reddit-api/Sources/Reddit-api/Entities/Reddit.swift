//
//  File.swift
//  
//
//  Created by Leandro Perez on 9/13/20.
//

import Foundation

public struct Reddit : Codable {
    private let data : Data

    private struct Data : Codable {
        let author: String
        let created: TimeInterval?
        let name: String
        let numComments: Int?
        let thumbnail: String
        let thumbnailHeight : Float?
        let thumbnailWidth : Float?
        let score: Int?
        let title: String
        let url: String
    }

    public let kind : String
    
    public var author: String {
        data.author
    }

    public var created: Date? {
        data.created.map(Date.init(timeIntervalSince1970:))
    }

    public var name: String {
        data.name
    }

    public var thumbnail: String {
        data.thumbnail
    }

    public var thumbnailHeight: Float? {
        data.thumbnailHeight
    }

    public var thumbnailWidth: Float? {
        data.thumbnailWidth
    }

    public var title: String {
        data.title
    }

    public var url: String {
        data.url
    }

    public var numberOfComments: Int {
        data.numComments ?? 0
    }

    public var score: Int {
        data.score ?? 0
    }
}
