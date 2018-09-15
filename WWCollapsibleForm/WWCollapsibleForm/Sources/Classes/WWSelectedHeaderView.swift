//
//  WWSelectedHeaderView.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
open class WWSelectedHeaderView: WWHeaderFooterView {
    public func expand() {
        self.reference.expand(section: self.section)
    }
}
