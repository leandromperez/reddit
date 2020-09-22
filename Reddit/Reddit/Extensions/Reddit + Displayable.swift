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
        return created?.timeFromNow() ?? "some time ago"
    }

    public var details: String {
        "Posted by: \(author), \(timeFromNow)."
    }
}

