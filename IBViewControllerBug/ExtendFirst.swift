//
//  ExtendFirst.swift
//  IBViewControllerBug
//
//  Created by Paul Goracke on 8/18/16.
//  Copyright © 2016 Corporation Unknown. All rights reserved.
//

import Foundation

protocol ViewControllerExtensible {
    func doSomething()
}

extension FirstViewController : ViewControllerExtensible {
    func doSomething() {
        // do nothing
    }
}