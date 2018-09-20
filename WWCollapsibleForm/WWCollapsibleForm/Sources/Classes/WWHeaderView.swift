//
//  WWHeaderFooterView.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
open class WWHeaderView: UIView, WWStatusApplier {
    internal var reference: WWCollapsibleForm!
    internal var section : Int!
    
    public var enableDecorator: WWStatusDecorator?
    public var disableDecorator: WWStatusDecorator?
}
