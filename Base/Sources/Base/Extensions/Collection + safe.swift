//
//  File.swift
//  
//
//  Created by Leandro Perez on 9/13/20.
//

import Foundation

public extension Collection {
    subscript(safe index: Index) -> Iterator.Element? {
        guard indices.contains(index) else { return nil }
        return self[index]
    }
}
