//
//  RedditAPITests.swift
//  RedditAPITests
//
//  Created by Leandro Perez on 9/13/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import XCTest
import Reddit_api

@testable import Reddit

class RedditAPITests: XCTestCase {

    let expectedNumberOfReddits = 10
    
    func testTopRedditsStubbingNow() throws {

        let stubIsCalled = expectation(description: "stub is called")

        RedditAPI().topReddits().call(stub: .now){ (result) in
            stubIsCalled.fulfill()

            guard let listing = try? result.get() else {
                XCTFail()
                return
            }

            XCTAssertEqual(listing.children.count , self.expectedNumberOfReddits)
        }

        waitForExpectations(timeout: 0.0001)
    }

    func testTopRedditsStubbingAfter4Milliseconds() throws {

        let stubIsCalled = expectation(description: "stub is called")

        RedditAPI().topReddits().call(stub: .after(time: .milliseconds(4))) { (result) in
            stubIsCalled.fulfill()

            guard let listing = try? result.get() else {
                XCTFail()
                return
            }

            XCTAssertEqual(listing.children.count , self.expectedNumberOfReddits)
        }

        waitForExpectations(timeout: 0.005)
    }


}

