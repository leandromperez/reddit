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

class RedditsPresenterMock : RedditsPresenter {

    var reddits: [Reddit]
    var error: Error?
    var onChanged: Action?

    internal init(reddits: [Reddit] = [], error: Error? = nil) {
        self.reddits = reddits
        self.error = error
    }

    func display(reddits: [Reddit]) {
        self.reddits = reddits
        onChanged?()
    }

    func display(newReddits: [Reddit]) {
        self.reddits.append(contentsOf: newReddits)
        onChanged?()
    }

    func display(error: Error) {
        self.error = error
        onChanged?()
    }
}

struct SomeError: Error {}

class RedditsInteractorTests: XCTestCase {

    func testLoadRedditsPresentsElements() throws {
        let displayCalled = expectation(description: "changed")
        let presenter = RedditsPresenterMock()
        presenter.onChanged = {
            displayCalled.fulfill()
        }
        XCTAssertEqual(presenter.reddits.count, 0)

        let interactor = RedditsInteractor(redditAPI: Current.redditAPI, stubbing: .now, presenter: presenter)

        interactor.loadReddits()

        waitForExpectations(timeout: 0.01, handler:nil)
        XCTAssertEqual(presenter.reddits.count, 10)
    }


    func testLoadRedditsPresentsError() throws {
        let displayCalled = expectation(description: "changed")
        let presenter = RedditsPresenterMock()
        presenter.onChanged = {
            displayCalled.fulfill()
        }

        XCTAssertEqual(presenter.reddits.count, 0)

        let interactor = RedditsInteractor(redditAPI: Current.redditAPI, stubbing: .error(SomeError()), presenter: presenter)

        interactor.loadReddits()
        
        waitForExpectations(timeout: 0.01, handler:nil)
        XCTAssertNotNil(presenter.error)
    }
}
