//
//  File.swift
//  
//
//  Created by Leandro Perez on 4/11/20.
//

import Foundation

public extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
}
