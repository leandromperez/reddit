//
//  EndpointPostable.swift
//  
//
//  Created by Leandro Perez on 4/28/20.
//

import Foundation

public protocol EndpointPostable : EndpointAccessible {
    associatedtype Body : Encodable
    static func endpoint(body: Body) -> Endpoint<Element>
    static func post(body: Body, onComplete: @escaping (Result<Element, Error>) -> ()) -> URLSessionDataTask
}

extension Endpoint where A : Codable & EndpointPostable {
    public static func post(baseUrl: String, body: A.Body) -> Endpoint<A> {
        let url = Endpoint.defaultGetUrl(baseUrl: baseUrl, endpointType: A.self)

        return Endpoint(json: .post, url: url, body: body)
    }

    @discardableResult
    public static func post(baseUrl: String,
                            behavior:StubbingBehavior = .never,
                            body: A.Body,
                            onComplete: @escaping (Result<A, Error>) -> ()) -> URLSessionDataTask? {
        let url = Endpoint.defaultGetUrl(baseUrl: baseUrl, endpointType: A.self)
        return Endpoint<A>(json: .post, url: url, body: body).call(behavior:behavior, onComplete: onComplete)
    }
}
