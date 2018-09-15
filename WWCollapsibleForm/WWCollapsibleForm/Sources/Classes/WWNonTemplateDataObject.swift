//
//  WWNonTemplateDataObject.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
public class WWNonTemplateDataObject : WWDataObject {
    internal var template: WWViewRepresentation!
    override internal init() {
        super.init()
    }
    
    public convenience init(view: WWItemView, height: CGFloat = UITableViewAutomaticDimension) {
        self.init()
        self.template = WWViewRepresentation (view: view, height: height)
    }
}
