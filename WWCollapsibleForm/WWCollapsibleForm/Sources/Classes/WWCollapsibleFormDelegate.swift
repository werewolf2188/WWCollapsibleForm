//
//  WWCollapsibleFormDelegate.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 9/20/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
public protocol WWCollapsibleFormDelegate {
    func modifyHeader(header: UIView, section: Int)
    func modifyItem(item: UIView, indexPath: IndexPath) //This should change to an indexer and not an index path
    func itemSelected(indexPath: IndexPath) //This should change to an indexer and not an index path
}
