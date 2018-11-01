//
//  WWSelectedHeaderView.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
/// Base class for selected headers. It has the same functionality as a header but with the ability to expand the section if needed.
open class WWSelectedHeaderView: WWHeaderView {
    /// Expands the section containing this view.
    public func expand() {
        self.removeDiagonal()
        self.reference.expand(section: self.section)
    }
}
