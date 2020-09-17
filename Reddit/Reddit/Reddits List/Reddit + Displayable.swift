//
//  Reddit + Displayable.swift
//  Reddit
//
//  Created by Leandro Perez on 9/17/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import Foundation
import Reddit_api

extension Reddit : Displayable {
    var subtitle: String {
        author
    }

    var thumbnailURL: URL? {
        URL(string: thumbnail)
    }

    var timeFromNow: String {
        guard let creationDate = created else {return "some time ago"}

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: creationDate, to: Date())
        if let years = components.yea, years > 0{
            return "\(years) years"
        } else 
        if let days = components.day, days > 0, let hour = components.hour {
            return "\(days) days, \(hour) hours"
        } else if let hours = components.hour, hours > 0, let minute = components.minute {
            return "\(hours) hours \(minute) minutes"
        } else if let minutes = components.minute, minutes > 0, let seconds = components.second {
            return "\(minutes) minutes \(seconds) seconds"
        } else if let seconds = components.second, seconds > 0 {
            return "\(seconds) seconds"
        }

        return "some time ago"
    }

    var details: String {
        "Score: \(score.description), posted by: \(author), created \(timeFromNow) from now."
    }
}

