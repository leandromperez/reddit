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
        let tenRedditsLoaded = expectation(description: "changed")

        let interactor = RedditsInteractor(redditAPI: Current.redditAPI, stubbing: .now)

        XCTAssertNil(interactor.reddit(at: IndexPath(row: 0, section: 0)))
        interactor.loadReddits() { result in
            if interactor.reddit(at: IndexPath(row: 9, section: 0)) != nil {
                tenRedditsLoaded.fulfill()
            }
        }

        waitForExpectations(timeout: 0.01, handler:nil)
    }

}
