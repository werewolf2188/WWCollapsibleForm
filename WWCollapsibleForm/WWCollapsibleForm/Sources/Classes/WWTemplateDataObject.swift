//
//  WWTemplateDataObject.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

/// This class represents an item that will use the template of a section.
public class WWTemplateDataObject : WWDataObject, WWAutoCollapsable {
    /// If it auto collapses when the item is pressed.
    public var autoCollapse : Bool = true
    public override init() {
        super.init()
    }
}
