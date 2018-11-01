//
//  WWSubGroupDataObject.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 9/25/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import UIKit

/// Enumerator that tells the header of a subgroup if it will collapse/expand by pressing the button or pressing the header.
public enum WWSubGroupDataObjectCollapse : Int {
    /// If the setting is by button, the header will not be able to do any functionality except for its expand/collapse button.
    case byButton
    /// If the setting is by cell, the user will be able to expand/collapse the sub group by hitting the header.
    case byCell
}

/// This class represents a data object that contains more data objects. This can lead to have multiple subgroups inside other sections or even inside other sub groups, making this a hierarchy tree.
public class WWSubGroupDataObject: WWDataObject {
    internal var data : [WWDataObject] = []
    internal var template: WWViewRepresentation!
    internal var headerTemplate: WWViewRepresentation!
    
    /// This setting sets how the sub group will be able to collapse.
    public var collapse: WWSubGroupDataObjectCollapse = .byCell
    
    override internal init() {
        super.init()
    }
    
    /// Initializes the sub group data with its own template for the inner items and a header template.
    /// - Parameter template: The template for the items that are data type `WWTemplateDataObject`.
    /// - Parameter header: The template for the header.
    public convenience init(template: WWViewRepresentation, headerTemplate: WWViewRepresentation){
        self.init()
        self.template = template
        self.headerTemplate = headerTemplate
    }
    
    /// Adds a new data object to the sub group. This function should be called during loading time.
    /// - Parameter data: the data object to be appended.
    public func appendData(object: WWDataObject) {
        object.internalParent = self
        self.data.append(object)
    }
}
