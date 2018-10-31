//
//  WWSubGroupDataObject.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 9/25/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import UIKit

public enum WWSubGroupDataObjectCollapse : Int {
    case byButton
    case byCell
}

public class WWSubGroupDataObject: WWDataObject {
    internal var data : [WWDataObject] = []
    internal var template: WWViewRepresentation!
    internal var headerTemplate: WWViewRepresentation!
    
    public var collapse: WWSubGroupDataObjectCollapse = .byCell
    
    override internal init() {
        super.init()
    }
    
    public convenience init(template: WWViewRepresentation, headerTemplate: WWViewRepresentation){
        self.init()
        self.template = template
        self.headerTemplate = headerTemplate
    }
    
    public func appendData(object: WWDataObject) {
        object.internalParent = self
        self.data.append(object)
    }
}
