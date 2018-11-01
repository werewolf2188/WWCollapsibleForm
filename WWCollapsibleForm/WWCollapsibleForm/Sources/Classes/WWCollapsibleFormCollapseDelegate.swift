//
//  WWCollapsibleFormCollapseDelegate.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 9/21/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

/// This protocol will be used whenever the form collapses or expands a section, during an item selection or if the form collapses or expands a section by triggering other event.
/// It will send infromation about the section and the form in 2 particular moments: before or after the event.
public protocol WWCollapsibleFormCollapseDelegate : NSObjectProtocol{
    
    /// Sends an alert before a section its been collapsed.
    /// - Parameter section: The index of the section to be collapsed.
    /// - Parameter form: The form that sent this event.
    func willCollapse(section: Int, form: WWCollapsibleForm)
    /// Sends an alert after a section has collapsed.
    /// - Parameter section: The index of the section that collapsed.
    /// - Parameter form: The form that sent this event.
    func didCollapse(section: Int, form: WWCollapsibleForm)
    /// Sends an alert before a section its been expanded.
    /// - Parameter section: The index of the section to be expanded.
    /// - Parameter form: The form that sent this event.
    func willExpand(section: Int, form: WWCollapsibleForm)
    /// Sends an alert aftert a section has expanded.
    /// - Parameter section: The index of the section that expanded.
    /// - Parameter form: The form that sent this event.
    func didExpand(section: Int, form: WWCollapsibleForm)
}
