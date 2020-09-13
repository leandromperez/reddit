//
//  File.swift
//  
//
//  Created by Leandro Perez on 9/13/20.
//

import Foundation

public struct Reddit : Codable {
    private struct Data : Codable {
        let author: String
        let thumbnail: String
        let title: String
        let url: String
    }

    private let data : Data
    public let kind : String
    
    public var author: String {
        data.author
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
}
