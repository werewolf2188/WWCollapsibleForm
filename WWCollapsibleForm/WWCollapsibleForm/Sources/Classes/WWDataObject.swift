//
//  WWDataObject.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

protocol WWAutoCollapsable : NSObjectProtocol {
    var autoCollapse : Bool { get set }
}

public class WWDataObject : NSObject {
    
    override init() {
        super.init()
    }
}
