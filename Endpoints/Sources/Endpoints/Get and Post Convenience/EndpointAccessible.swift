//
//  File.swift
//  
//
//  Created by Leandro Perez on 4/28/20.
//

import Foundation

public protocol EndpointAccessible {
    associatedtype Element : Codable
    static var path: String {get}
}


public extension Endpoint where A : EndpointAccessible {
    static func defaultGetUrl<T>(baseUrl: String,
                                 endpointType: T.Type,
                                 id: String? = nil) -> URL where T:Codable {
        let endpoint = "\(baseUrl)\(A.path)"
        if let id = id {
            return URL(string:"\(endpoint)/\(id)")!
        }
        return URL(string:endpoint)!
    }
}

extension Endpoint where A : Codable & EndpointAccessible {
    public static func getAll(baseUrl: String) -> Endpoint<[A]> {
        Endpoint<[A]>(json: .get, url: Endpoint.defaultGetUrl(baseUrl: baseUrl, endpointType: A.self))
    }

    public static func getPaged(baseUrl: String, page:Int, perPage:Int) -> Endpoint<PagedResult<A>> {
        return Endpoint<PagedResult<A>>(json: .get,
                                        url: Endpoint.defaultGetUrl(baseUrl: baseUrl, endpointType: A.self),
                                        query: ["page": page.description, "per_page": perPage.description])
    }

    public static func get(baseUrl: String,
                           id: String? = nil,
                           accept: ContentType = .json,
                           headers: [String: String] = [:],
                           expectedStatusCode: @escaping (Int) -> Bool = expected200to300,
                           timeOutInterval: TimeInterval = 10,
                           query: [String: String] = [:],
                           decoder: JSONDecoder = JSONDecoder()) -> Endpoint<A> {
        Endpoint(.get,
                 url: Endpoint.defaultGetUrl(baseUrl: baseUrl, endpointType: A.self),
                 accept: accept,
                 body: nil,
                 headers: headers,
                 expectedStatusCode: expectedStatusCode,
                 timeOutInterval: timeOutInterval,
                 query: query) { data, _ in
                    return Result {
                        guard let dat = data else { throw NoDataError() }
                        return try decoder.decode(A.self, from: dat)
                    }
        }
    }
}
