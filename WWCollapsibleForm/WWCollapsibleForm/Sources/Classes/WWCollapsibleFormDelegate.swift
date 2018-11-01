//
//  WWCollapsibleFormDelegate.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 9/20/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

/// This protocol is meant to be used to track the changes tha happen to a part of a section. Whether is the header or
/// the item, it was meant to allow the sub views to apply data structures, outside the component. It gives the neccessary
/// data so the view can be tracked.
///
/// It also helps when an item gets seleected, or if the item has options, when an option is selected.
@objc public protocol WWCollapsibleFormDelegate {
    /// When a header is going to appear in a section, this function is executed.
    /// - Parameters:
    ///     - header: The view of the header.
    ///     - section: The index of the section.
    func modifyHeader(header: UIView, section: Int)
    /// When an item is going to appear in a section, this function is executed.
    /// - Parameters:
    ///     - item: The view of the item.
    ///     - data: the data object related to the item.
    ///     - section: The index of the section.
    func modifyItem(item: UIView, data: WWDataObject, section: Int)
    /// This functions is exectured when an item is selected, to retrieve the data object related to the item.
    /// - Parameters:
    ///     - data: The data object related to the item.
    ///     - section: the index of the section.
    func itemSelected(data: WWDataObject, section: Int)
    /// When a data object has options related to it, and an option is pressed, this function will be executed, to
    /// let the owner know that an option has been pressed.
    /// - Parameters:
    ///     - option: The optione pressed.
    ///     - data: The data object related to the item.
    ///     - section: the index of the section.
    /// - Remark: This function is optional.
    @objc optional func optionSelected(option: WWOptionViewItem, data: WWDataObject, section: Int)
}
