//
//  Endpoint.swift
//  
//
//  Created by Leandro Perez on 9/13/20.
//

import Foundation
// Core implementation taken from https://github.com/objcio/tiny-networking.
// Stubbed behavior inspired in Moya.

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Built-in Content Types
public enum ContentType: String {
    case json = "application/json"
    case xml = "application/xml"
}

/// Returns `true` if `code` is in the 200..<300 range.
public func expected200to300(_ code: Int) -> Bool {
    return code >= 200 && code < 300
}

/// This describes an endpoint returning `A` values. It contains both a `URLRequest` and a way to parse the response.
public struct Endpoint<A> {

    /// The HTTP Method
    public enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }

    /// The request for this endpoint
    public var request: URLRequest

    /// This is used to (try to) parse a response into an `A`.
    var parse: (Data?, URLResponse?) -> Result<A, Error>

    /// This is used to check the status code of a response.
    public var expectedStatusCode: (Int) -> Bool = expected200to300

    /// Transforms the result
    public func map<B>(_ f: @escaping (A) -> B) -> Endpoint<B> {
        return Endpoint<B>(request: request, expectedStatusCode: expectedStatusCode, parse: { value, response in
            self.parse(value, response).map(f)
        })
    }

    /// Transforms the result
    public func compactMap<B>(_ transform: @escaping (A) -> Result<B, Error>) -> Endpoint<B> {
        return Endpoint<B>(request: request, expectedStatusCode: expectedStatusCode, parse: { data, response in
            self.parse(data, response).flatMap(transform)
        })
    }

    /// Create a new Endpoint.
    ///
    /// - Parameters:
    ///   - method: the HTTP method
    ///   - url: the endpoint's URL
    ///   - accept: the content type for the `Accept` header
    ///   - contentType: the content type for the `Content-Type` header
    ///   - body: the body of the request.
    ///   - headers: additional headers for the request
    ///   - expectedStatusCode: the status code that's expected. If this returns false for a given status code, parsing fails.
    ///   - timeOutInterval: the timeout interval for his request
    ///   - query: query parameters to append to the url
    ///   - parse: this converts a response into an `A`.
    public init(_ method: Method,
                url: URL,
                accept: ContentType? = nil,
                contentType: ContentType? = nil,
                body: Data? = nil,
                headers: [String:String] = [:],
                expectedStatusCode: @escaping (Int) -> Bool = expected200to300,
                timeOutInterval: TimeInterval = 10,
                query: [String: String] = [:],
                parse: @escaping (Data?, URLResponse?) -> Result<A, Error>) {
        var requestUrl : URL
        if query.isEmpty {
            requestUrl = url
        } else {
            var comps = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            comps.queryItems = comps.queryItems ?? []
            comps.queryItems!.append(contentsOf: query.map { URLQueryItem(name: $0.0, value: $0.1) })
            requestUrl = comps.url!
        }
        request = URLRequest(url: requestUrl)
        if let a = accept {
            request.setValue(a.rawValue, forHTTPHeaderField: "Accept")
        }
        if let ct = contentType {
            request.setValue(ct.rawValue, forHTTPHeaderField: "Content-Type")
        }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.timeoutInterval = timeOutInterval
        request.httpMethod = method.rawValue

        // body *needs* to be the last property that we set, because of this bug: https://bugs.swift.org/browse/SR-6687
        request.httpBody = body

        self.expectedStatusCode = expectedStatusCode
        self.parse = parse
    }


    /// Creates a new Endpoint from a request
    ///
    /// - Parameters:
    ///   - request: the URL request
    ///   - expectedStatusCode: the status code that's expected. If this returns false for a given status code, parsing fails.
    ///   - parse: this converts a response into an `A`.
    public init(request: URLRequest,
                expectedStatusCode: @escaping (Int) -> Bool = expected200to300,
                parse: @escaping (Data?, URLResponse?) -> Result<A, Error>) {
        self.request = request
        self.expectedStatusCode = expectedStatusCode
        self.parse = parse
    }
}

// MARK: - CustomStringConvertible
extension Endpoint: CustomStringConvertible {
    public var description: String {
        let data = request.httpBody ?? Data()
        return "\(request.httpMethod ?? "GET") \(request.url?.absoluteString ?? "<no url>") \(String(data: data, encoding: .utf8) ?? "")"
    }
}

// MARK: - where A == (), used in cases we don't need to parse a result
extension Endpoint where A == () {
    /// Creates a new endpoint without a parse function.
    ///
    /// - Parameters:
    ///   - method: the HTTP method
    ///   - url: the endpoint's URL
    ///   - accept: the content type for the `Accept` header
    ///   - contentType: the content type for the `Content-Type` header
    ///   - body: the body of the request.
    ///   - headers: additional headers for the request
    ///   - expectedStatusCode: the status code that's expected. If this returns false for a given status code, parsing fails.
    ///   - timeOutInterval: the timeout interval for his request
    ///   - query: query parameters to append to the url
    public init(_ method: Method,
                url: URL,
                accept: ContentType? = nil,
                contentType: ContentType? = nil,
                body: Data? = nil,
                headers: [String:String] = [:],
                expectedStatusCode: @escaping (Int) -> Bool = expected200to300,
                timeOutInterval: TimeInterval = 10,
                query: [String:String] = [:]) {
        self.init(method, url: url, accept: accept, contentType: contentType, body: body, headers: headers, expectedStatusCode: expectedStatusCode, timeOutInterval: timeOutInterval, query: query, parse: { _, _ in .success(()) })
    }

    /// Creates a new endpoint without a parse function.
    ///
    /// - Parameters:
    ///   - method: the HTTP method
    ///   - json: the HTTP method
    ///   - url: the endpoint's URL
    ///   - accept: the content type for the `Accept` header
    ///   - body: the body of the request. This gets encoded using a default `JSONEncoder` instance.
    ///   - headers: additional headers for the request
    ///   - expectedStatusCode: the status code that's expected. If this returns false for a given status code, parsing fails.
    ///   - timeOutInterval: the timeout interval for his request
    ///   - query: query parameters to append to the url
    ///   - encoder: the encoder that's used for encoding `A`s.
    public init<B: Encodable>(json method: Method,
                              url: URL,
                              accept: ContentType? = .json,
                              body: B,
                              headers: [String:String] = [:],
                              expectedStatusCode: @escaping (Int) -> Bool = expected200to300,
                              timeOutInterval: TimeInterval = 10,
                              query: [String:String] = [:],
                              encoder: JSONEncoder = JSONEncoder()) {
        let b = try! encoder.encode(body)
        self.init(method, url: url, accept: accept, contentType: .json, body: b, headers: headers, expectedStatusCode: expectedStatusCode, timeOutInterval: timeOutInterval, query: query, parse: { _, _ in .success(()) })
    }
}

// MARK: - where A: Decodable
extension Endpoint where A: Decodable {
    /// Creates a new endpoint.
    ///
    /// - Parameters:
    ///   - method: the HTTP method
    ///   - url: the endpoint's URL
    ///   - accept: the content type for the `Accept` header
    ///   - headers: additional headers for the request
    ///   - expectedStatusCode: the status code that's expected. If this returns false for a given status code, parsing fails.
    ///   - timeOutInterval: the timeout interval for his request
    ///   - query: query parameters to append to the url
    ///   - decoder: the decoder that's used for decoding `A`s.
    public init(json method: Method,
                url: URL,
                accept: ContentType = .json,
                headers: [String: String] = [:],
                expectedStatusCode: @escaping (Int) -> Bool = expected200to300,
                timeOutInterval: TimeInterval = 10,
                query: [String: String] = [:],
                decoder: JSONDecoder = JSONDecoder()) {
        self.init(method, url: url,
                  accept: accept,
                  body: nil, headers: headers,
                  expectedStatusCode: expectedStatusCode,
                  timeOutInterval: timeOutInterval,
                  query: query) { data, _ in
                    return Result {
                        guard let dat = data else { throw NoDataError() }
                        return try decoder.decode(A.self, from: dat)
                    }
        }
    }

    /// Creates a new endpoint.
    ///
    /// - Parameters:
    ///   - method: the HTTP method
    ///   - url: the endpoint's URL
    ///   - accept: the content type for the `Accept` header
    ///   - body: the body of the request. This is encoded using a default encoder.
    ///   - headers: additional headers for the request
    ///   - expectedStatusCode: the status code that's expected. If this returns false for a given status code, parsing fails.
    ///   - timeOutInterval: the timeout interval for his request
    ///   - query: query parameters to append to the url
    ///   - decoder: the decoder that's used for decoding `A`s.
    ///   - encoder: the encoder that's used for encoding `A`s.
    public init<B: Encodable>(json method: Method,
                              url: URL,
                              accept: ContentType = .json,
                              body: B? = nil,
                              headers: [String: String] = [:],
                              expectedStatusCode: @escaping (Int) -> Bool = expected200to300,
                              timeOutInterval: TimeInterval = 10,
                              query: [String: String] = [:],
                              decoder: JSONDecoder = JSONDecoder(),
                              encoder: JSONEncoder = JSONEncoder()) {
        let b = body.map { try! encoder.encode($0) }
        self.init(method, url: url,
                  accept: accept,
                  contentType: .json,
                  body: b,
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
