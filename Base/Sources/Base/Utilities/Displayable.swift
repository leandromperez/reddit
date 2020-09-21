//
//  File.swift
//  
//
//  Created by Leandro Perez on 9/18/20.
//

import Foundation

public protocol DisplayableContainer {
    func set(displayable: Displayable?, checked: Bool)
}

public protocol Displayable {
    var subtitle : String {get}
    var thumbnailURL : URL? {get}
    var title: String {get}
    var details : String {get}
}
