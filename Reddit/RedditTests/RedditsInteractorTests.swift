//
//  RedditsInteractorTests.swift
//  RedditTests
//
//  Created by Leandro Perez on 9/15/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import XCTest
import Reddit_api
import Base

@testable import Reddit

struct SomeError: Error {}

class RedditsInteractorTests: XCTestCase {

    func testLoadRedditsChangesReddits() throws {
        let redditsAreLoaded = expectation(description: "changed")

        let interactor = RedditsInteractor(redditAPI: Current.redditAPI, stubbing: .now)

        XCTAssertNil(interactor.reddit(at: IndexPath(row: 0, section: 0)))
        interactor.loadReddits(limit:4) { result in
            if interactor.reddit(at: IndexPath(row: 3, section: 0)) != nil {
                redditsAreLoaded.fulfill()
            }
        }

        waitForExpectations(timeout: 0.1, handler:nil)
    }


    func testLoadMoreRedditsAddsNewReddits() throws {
        let tenRedditsLoaded = expectation(description: "changed")

        let interactor = RedditsInteractor(redditAPI: Current.redditAPI, stubbing: .now)
        let interactorAll = RedditsInteractor(redditAPI: Current.redditAPI, stubbing: .now)

        var allReddits = [Reddit]()
        interactorAll.loadReddits { (result) in
            allReddits = try! result.get()

            XCTAssertNil(interactor.reddit(at: IndexPath(row: 0, section: 0)))
            interactor.loadReddits(limit: 1) { _ in

                XCTAssertNotNil(interactor.reddit(at: IndexPath(row: 0, section: 0)))
                XCTAssertNil(interactor.reddit(at: IndexPath(row: 1, section: 0)))

                let rest : [Reddit] = Array(allReddits.dropFirst())
                interactor.stubbing = .nowWithElement(rest)
                interactor.loadMoreReddits { (result) in
                    if interactor.reddit(at: IndexPath(row: 2, section: 0)) != nil {
                        tenRedditsLoaded.fulfill()
                    }
                }
            }
        }

        waitForExpectations(timeout: 0.1, handler:nil)
    }

}
