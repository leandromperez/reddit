//
//  Date + timeFromNow.swift
//  Reddit
//
//  Created by Leandro Perez on 9/21/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import Foundation

extension Date {

    /// Create a string representing the time elapsed since the receiver to the current date.
    /// - See the unit tests for more info.
    /// - Example: `Date().addingTimeInterval(-oneHour - (oneMinute * 20))` will return `"1 hour, 20 minutes"`
    /// - Parameter calendar:  is the calendar used to perform the calculations. `current` by default
    /// - Returns: a string, in english, representing the time elapsed since the receiver to the current date.
    func timeFromNow(_ calendar: Calendar = .current) -> String {
        let suffix = " from now."
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: Current.date())
        if let years = components.year, years > 0 {
            return String(elements: years, unit: "year") + suffix
        } else if let months = components.month, months > 0 {
            return String(elements: months, unit: "month") + suffix
        } else if let days = components.day, days > 0, let hours = components.hour {
            return String(days:days, hours: hours) + suffix
        } else if let hours = components.hour, hours > 0, let minutes = components.minute {
            return String(hours: hours, minutes: minutes) + suffix
        } else if let minutes = components.minute, minutes > 0, let seconds = components.second {
            return String(minutes: minutes, seconds: seconds) + suffix
        } else if let seconds = components.second, seconds > 0 {
            return String(seconds: seconds) + suffix
        } else {
            return "right now"
        }
    }
}

fileprivate extension String {

    init (elements: Int, unit: String) {
        if elements == 0 {
            self =  ""
        } else if elements == 1{
            self = "1 \(unit)"
        } else {
            self = "\(elements) \(unit)s"
        }
    }

    init (majorUnit:String, majorValue: Int,  minorUnit: String, minorValue: Int) {
        let minorUnitValue = String(elements: minorValue, unit: minorUnit)
        let minorUnitPart = (minorValue == 0) ? "" : (", " + minorUnitValue)
        if majorValue == 0 {
            self = minorUnitValue
        } else if majorValue == 1 {
            self = "1 \(majorUnit)" + minorUnitPart
        } else {
            self = "\(majorValue) \(majorUnit)s" + minorUnitPart
        }
    }

    init (seconds: Int) {
        self.init(elements: seconds, unit: "second")
    }

    init (hours: Int) {
        self.init(elements: hours, unit: "hour")
    }

    init (minutes: Int) {
        self.init(elements: minutes, unit: "minute")
    }

    init (days: Int, hours: Int) {
        self.init( majorUnit: "day", majorValue: days, minorUnit: "hour", minorValue: hours )
    }

    init (hours: Int, minutes: Int) {
        self.init( majorUnit: "hour", majorValue: hours, minorUnit: "minute", minorValue: minutes )
    }

    init (minutes: Int, seconds: Int) {
        self.init( majorUnit: "minute", majorValue: minutes, minorUnit: "second", minorValue: seconds )
    }
}
