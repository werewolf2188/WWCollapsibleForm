//
//  WWItemView.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
open class WWItemView : UIView {
    internal var reference: WWCollapsibleForm!
    internal var indexPath: IndexPath!
    
    public var enableDecorator: WWStatusDecorator?
    public var disableDecorator: WWStatusDecorator?
    
    public func collapse() {
        self.reference.collapse(indexPath: indexPath)
    }
}
