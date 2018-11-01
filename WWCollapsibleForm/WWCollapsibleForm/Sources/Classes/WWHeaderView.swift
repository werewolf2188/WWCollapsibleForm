//
//  WWHeaderFooterView.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

/// This class is optional to use, but it will help a view to be set as a header. It sets the basic functions a header can have.
open class WWHeaderView: UIView, WWStatusApplier {
    internal var reference: WWCollapsibleForm!
    internal var section : Int!
    
    /// The decorator that will be applied when a section is enabled.
    public var enableDecorator: WWStatusDecorator?
    /// The decorator that will be applied when a section is disabled.
    public var disableDecorator: WWStatusDecorator?
}
