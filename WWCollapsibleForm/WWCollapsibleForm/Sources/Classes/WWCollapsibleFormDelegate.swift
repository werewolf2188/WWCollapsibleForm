//
//  WWCollapsibleFormDelegate.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 9/20/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
@objc public protocol WWCollapsibleFormDelegate {
    func modifyHeader(header: UIView, section: Int)
    func modifyItem(item: UIView, data: WWDataObject, section: Int)
    func itemSelected(data: WWDataObject, section: Int)
    @objc optional func optionSelected(option: WWOptionViewItem, data: WWDataObject, section: Int)
}
