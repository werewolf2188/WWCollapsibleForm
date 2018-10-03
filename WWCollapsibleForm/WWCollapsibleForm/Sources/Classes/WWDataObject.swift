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
    
    internal var internalParent : WWSubGroupDataObject?
    public var parent: WWSubGroupDataObject? {
        get {
            return internalParent
        }
    }
    
    var options : [WWOptionViewItem] = []
    
    public func appendOptions(option : WWOptionViewItem) {
        self.options.append(option)
    }
    
    public override var hash: Int {
        get {
            return ObjectIdentifier(self).hashValue
        }
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        if let otherObject = object as? WWDataObject {
            return self.hash == otherObject.hash
        }
        return false
    }
    
    public func isEqual(to data: WWDataObject) -> Bool {
        return self.isEqual(data)
    }
}
