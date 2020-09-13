import XCTest
@testable import Reddit_api

final class Reddit_apiTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Reddit_api().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
