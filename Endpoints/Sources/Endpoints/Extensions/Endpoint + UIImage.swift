//
//  File.swift
//  
//
//  Created by Leandro Perez on 4/28/20.
//

import Foundation
import Base


public struct ImageError: Error {}

public extension Endpoint where A == Image {

    init(imageURL: URL) {
        self = Endpoint(.get, url: imageURL) { (data, response) in
            Result {
                guard let d = data, let i = Image(data: d) else {
                    throw ImageError()
                }
                return i
            }
        }
    }

    @discardableResult
    func call(session : URLSession = .shared,
              dispatchQueue:DispatchQueue = .main,
              onComplete: @escaping (Result<A, Error>) -> ()) -> URLSessionDataTask? {
        session.load(self, dispatchQueue: dispatchQueue, onComplete: onComplete)
    }
}


