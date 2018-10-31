//
//  WWTemplateDataObject.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
public class WWTemplateDataObject : WWDataObject, WWAutoCollapsable {
    public var autoCollapse : Bool = true
    public override init() {
        super.init()
    }
}
