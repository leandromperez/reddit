//
//  MainSplitViewController.swift
//  Reddit
//
//  Created by Leandro Perez on 9/14/20.
//  Copyright © 2020 Leandro Perez. All rights reserved.
//

import UIKit
import Base

class MainSplitViewController: UISplitViewController, Storyboarded {

    weak var coordinator : MainCoordinator!

    init(coordinator: MainCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        coordinator.start()
    }
}
