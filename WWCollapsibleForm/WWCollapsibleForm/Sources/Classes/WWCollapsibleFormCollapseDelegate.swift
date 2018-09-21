//
//  WWCollapsibleFormCollapseDelegate.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 9/21/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
public protocol WWCollapsibleFormCollapseDelegate : NSObjectProtocol{
    func willCollapse(section: Int, form: WWCollapsibleForm)
    func didCollapse(section: Int, form: WWCollapsibleForm)
    func willExpand(section: Int, form: WWCollapsibleForm)
    func didExpand(section: Int, form: WWCollapsibleForm)
}
