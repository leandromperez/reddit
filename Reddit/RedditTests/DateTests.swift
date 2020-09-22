//
//  DateTests.swift
//  RedditTests
//
//  Created by Leandro Perez on 9/21/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import XCTest
import Reddit_api
@testable import Reddit

class DateTests: XCTestCase {

    func testTimeFromNow() throws {
        let oneDay : TimeInterval = 24 * 60 * 60
        let oneHour : TimeInterval = 60 * 60
        let oneMinute: TimeInterval = 60

        XCTAssertEqual(Date().timeFromNow(), "right now")

        let yesterday = Date().addingTimeInterval(-oneDay)
        XCTAssertEqual(yesterday.timeFromNow(), "1 day from now.")

        let twoHoursBeforeYesterday = Date().addingTimeInterval(-oneDay - (oneHour * 2))
        XCTAssertEqual(twoHoursBeforeYesterday.timeFromNow(), "1 day, 2 hours from now.")

        let almost2Days = Date().addingTimeInterval(-oneDay - (oneHour * 23))
        XCTAssertEqual(almost2Days.timeFromNow(), "1 day, 23 hours from now.")

        let twoDays = Date().addingTimeInterval(-oneDay - (oneHour * 24))
        XCTAssertEqual(twoDays.timeFromNow(), "2 days from now.")

        let oneHourAgo = Date().addingTimeInterval(-oneHour )
        XCTAssertEqual(oneHourAgo.timeFromNow(), "1 hour from now.")

        let oneHour20MinutesAgo = Date().addingTimeInterval(-oneHour - (oneMinute * 20))
        XCTAssertEqual(oneHour20MinutesAgo.timeFromNow(), "1 hour, 20 minutes from now.")

        let twoHoursAgo = Date().addingTimeInterval(-oneHour * 2 )
        XCTAssertEqual(twoHoursAgo.timeFromNow(), "2 hours from now.")

        let twoHoursAgo20MinutesAgo = Date().addingTimeInterval(-oneHour * 2 - (oneMinute * 20))
        XCTAssertEqual(twoHoursAgo20MinutesAgo.timeFromNow(), "2 hours, 20 minutes from now.")

        let twentySecondsAgo = Date().addingTimeInterval(-20)
        XCTAssertEqual(twentySecondsAgo.timeFromNow(), "20 seconds from now.")

        let aSecondAgo = Date().addingTimeInterval(-1)
        XCTAssertEqual(aSecondAgo.timeFromNow(), "1 second from now.")

        let aYearAgo = Date().addingTimeInterval(-366 * oneDay)
        XCTAssertEqual(aYearAgo.timeFromNow(), "1 year from now.")

        let twoYearsAgo = Date().addingTimeInterval(-366 * oneDay * 2)
        XCTAssertEqual(twoYearsAgo.timeFromNow(), "2 years from now.")

    }
}
