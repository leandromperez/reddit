//
//  StubbingBehavior.swift
//  Endpoints
//
//  Created by Leandro Perez on 5/26/19.
//  Copyright © 2019 Leandro Perez. All rights reserved.
//

import Foundation
import Base

///A StubbingBehavior can call an endpoint and provide stub data
/// - now returns the stub data, typically from a json file named `stub-Workout,json` for example, where `Workout` is the Element of the `Endpoint<Workout>`
/// - after functions as now, but with a delay
/// - never will use the nsurl session, requestiing the actual endpoint
public enum StubbingBehavior {
    case never
    case now
    case nowWithElement(Any)
    case after(time:DispatchTimeInterval)
    case error(Error)
}

public extension StubbingBehavior {

    @discardableResult
    func call<Element:Decodable>(endpoint: Endpoint<Element>,
                                 dispatchQueue : DispatchQueue = .main,
                                 urlSession:URLSession = .shared,
                                 stub : @escaping () throws -> Element = {try Element.fromStubJson()},
                                 onComplete: @escaping (Result<Element, Error>) -> ()) -> URLSessionDataTask? {
        switch self {
        case .never:
            return urlSession.load(endpoint, onComplete: onComplete)
        case .now:
            dispatchQueue.async {
                self.stubbedElementFromJson(endpoint: endpoint, stub: stub, callback: onComplete)
            }
        case .after(let dispatchTime):
            dispatchQueue.asyncAfter(deadline: .now() + dispatchTime){
                self.stubbedElementFromJson(endpoint: endpoint, stub: stub, callback: onComplete)
            }
        case .error(let error):
            dispatchQueue.async {
                onComplete(.failure(error))
            }
        case .nowWithElement(let element):
            dispatchQueue.async {
                onComplete(.success(element as! Element))
            }
        }

        return nil
    }

    func stubbedElementFromJson<Element:Decodable>(endpoint: Endpoint<Element>,
                                                   stub : @escaping () throws -> Element = {try Element.fromStubJson()},
                                                   callback:(Result<Element, Error>) -> Void) {
        do {
            let successElement : Element = try stub()
            callback(.success(successElement))
        }
        catch let error {
            callback(.failure(error))
        }
    }
}

