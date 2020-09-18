//
//  File.swift
//  
//
//  Created by Leandro Perez on 9/18/20.
//

import Foundation

public protocol DisplayableContainer {
    var displayable: Displayable? {get set}
}

public protocol Displayable {
    var subtitle : String {get}
    var thumbnailURL : URL? {get}
    var title: String {get}
    var details : String {get}
}
