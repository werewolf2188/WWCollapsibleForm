//
//  WWSelectedHeaderView.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
open class WWSelectedHeaderView: WWHeaderView {
    public func expand() {
        self.removeDiagonal()
        self.reference.expand(section: self.section)
    }
}
