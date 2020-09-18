//
//  RedditsPresenter.swift
//  Reddit
//
//  Created by Leandro Perez on 9/15/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import Foundation
import Reddit_api

protocol RedditsPresenter : AnyObject {
    func display(reddits: [Reddit])
    func display(newReddits: [Reddit])
    func display(error: Error)
}
