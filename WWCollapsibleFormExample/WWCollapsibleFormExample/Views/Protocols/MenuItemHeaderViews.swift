//
//  MenuItemHeaderViews.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/20/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

protocol MenuHeaderView : NSObjectProtocol {
    func set(title:String)
    func setSubtitle(title:String?)
}

protocol MenuItemView : NSObjectProtocol {
    func set(productName:String)
    func setImage(image:String?)
    func set(money: String)
}

protocol MenuSelectedHeaderView : MenuHeaderView, MenuItemView {
    
}
