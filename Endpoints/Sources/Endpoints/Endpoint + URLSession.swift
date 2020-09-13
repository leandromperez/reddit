
//
//  File.swift
//  
//
//  Created by Leandro Perez on 9/13/20.
//

import Foundation

/// Signals that a response's data was unexpectedly nil.
public struct NoDataError: Error {
    public init() { }
}

/// An unknown error
public struct UnknownError: Error {
    public init() { }
}

/// Signals that a response's status code was wrong.
public struct WrongStatusCodeError: Error {
    public let statusCode: Int
    public let response: HTTPURLResponse?
    public let responseBody: Data?
    public init(statusCode: Int, response: HTTPURLResponse?, responseBody: Data?) {
        self.statusCode = statusCode
        self.response = response
        self.responseBody = responseBody
    }
}

extension URLSession {
    @discardableResult
    /// Loads an endpoint by creating (and directly resuming) a data task.
    ///
    /// - Parameters:
    ///   - endpoint: The endpoint.
    ///   - onComplete: The completion handler.
    /// - Returns: The data task.
    public func load<A>(_ endpoint: Endpoint<A>, onComplete: @escaping (Result<A, Error>) -> ()) -> URLSessionDataTask {
        let r = endpoint.request
        let task = dataTask(with: r, completionHandler: { data, resp, err in
            if let err = err {
                onComplete(.failure(err))
                return
            }

            guard let h = resp as? HTTPURLResponse else {
                onComplete(.failure(UnknownError()))
                return
            }

            guard endpoint.expectedStatusCode(h.statusCode) else {
                onComplete(.failure(WrongStatusCodeError(statusCode: h.statusCode, response: h, responseBody: data)))
                return
            }

            onComplete(endpoint.parse(data,resp))
        })
        task.resume()
        return task
    }
}
