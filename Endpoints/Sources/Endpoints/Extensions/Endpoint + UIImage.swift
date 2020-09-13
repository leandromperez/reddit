//
//  File.swift
//  
//
//  Created by Leandro Perez on 4/28/20.
//

import Foundation
import Base

struct ImageError: Error {}

extension Endpoint where A == Image {
    init(imageURL: URL) {
        self = Endpoint(.get, url: imageURL) { (data, response) in
            Result {
                guard let d = data, let i = Image(data: d) else { throw ImageError() }
                return i
            }
        }
    }
}
