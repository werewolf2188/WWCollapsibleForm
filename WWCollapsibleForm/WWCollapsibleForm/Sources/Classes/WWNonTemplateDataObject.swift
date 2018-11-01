//
//  WWNonTemplateDataObject.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
/// When a data object does not want to use the template object of a section, this data type can be used to specify a unique view.
public class WWNonTemplateDataObject : WWDataObject, WWAutoCollapsable {
    /// If it auto collapses when the item is pressed.
    public var autoCollapse : Bool = true
    internal var template: WWViewRepresentation!
    override internal init() {
        super.init()
    }
    
    /// Use this initializer to create a non template data object.
    /// - Parameter view: The item view to be used.
    /// - Parameter height: the height of the view that will be rendered.
    public convenience init(view: WWItemView, height: CGFloat = UITableViewAutomaticDimension) {
        self.init()
        self.template = WWViewRepresentation (view: view, height: height)
    }
}
