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
    
    internal var deleteOption : WWOptionViewItem!
    internal var internalParent : WWSubGroupDataObject?
    public var parent: WWSubGroupDataObject? {
        get {
            return internalParent
        }
    }
    
    var options : [WWOptionViewItem] = []
    
    public func createDeleteOption(title: String = "Delete", backgroundColor: UIColor? = UIColor.red, image : UIImage? = nil, padding : CGFloat = 10) -> WWOptionViewItem {
        if deleteOption == nil {
            deleteOption = WWOptionViewItem(title: title, backgroundColor: backgroundColor, image: image, padding: padding)
        }
        
        return deleteOption
    }
    
    public func appendOptions(option : WWOptionViewItem) {
        if option == deleteOption {
            let searchedDeleteOption : WWOptionViewItem? = self.options.filter({ $0 == option }).first
            if searchedDeleteOption != nil {
                return
            }
        }
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
