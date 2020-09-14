//
//  MasterViewModel.swift
//  Reddit
//
//  Created by Leandro Perez on 9/13/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import Foundation
import Reddit_api
import Base

struct MasterViewModel<Element: Displayable> {
    let error: Error?
    let elements : [Element]
}

protocol Displayable {
    var author : String {get}
    var thumbnail : String {get}
    var title: String {get}
    var numberOfComments : Int {get}
}

extension Reddit : Displayable {}
