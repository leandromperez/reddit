//
//  Reddit + Displayable.swift
//  Reddit
//
//  Created by Leandro Perez on 9/17/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import Foundation
import Reddit_api
import Base

extension Reddit : Displayable {
    public var subtitle: String {
        "Score: \(score.description)"
    }

    public var thumbnailURL: URL? {
        URL(string: thumbnail)
    }

    var timeFromNow: String {
        let unknown = "some time ago"
        guard let creationDate = created else {return unknown}

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: creationDate, to: Date())
        if let years = components.year, years > 0 {
            return "\(years) years"
        } else if let months = components.month, months > 0 {
            return "\(months) months"
        } else if let days = components.day, days > 0, let hour = components.hour {
            return "\(days) days, \(hour) hours"
        } else if let hours = components.hour, hours > 0, let minute = components.minute {
            return "\(hours) hours \(minute) minutes"
        } else if let minutes = components.minute, minutes > 0, let seconds = components.second {
            return "\(minutes) minutes \(seconds) seconds"
        } else if let seconds = components.second, seconds > 0 {
            return "\(seconds) seconds"
        }

        return unknown
    }

    public var details: String {
        "Posted by: \(author), \(timeFromNow) from now."
    }
}

