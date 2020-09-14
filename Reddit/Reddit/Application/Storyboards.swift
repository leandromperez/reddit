//
//  Storyboards.swift
//  Reddit
//
//  Created by Leandro Perez on 9/13/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import Foundation
import Base

enum Storyboards: String {
    case main
}

extension Storyboards : Storyboard {
    var bundle: Bundle {
        .main
    }
}

