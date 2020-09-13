//
//  File.swift
//  
//
//  Created by Leandro Perez on 4/11/20.
//

import Foundation

#if os(macOS)

import AppKit

public typealias ViewController = NSViewController
public typealias StoryboardType = NSStoryboard
public typealias ImageView = NSImageView
public typealias Image = NSImage

#elseif canImport(UIKit)

import UIKit

public typealias ViewController = UIViewController
public typealias StoryboardType = UIStoryboard
public typealias ImageView = UIImageView
public typealias Image = UIImage

#endif


