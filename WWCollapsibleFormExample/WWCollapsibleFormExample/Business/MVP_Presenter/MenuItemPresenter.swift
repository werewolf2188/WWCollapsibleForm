//
//  MenuItemPresenter.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/20/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
protocol MenuItemViewPresenter : NSObjectProtocol {
    var itemView: MenuItemView! { get set }
    var item : MenuItem! { get set }
    
    func showItem()
}

class MenuItemPresenter : NSObject, MenuItemViewPresenter {
    var itemView: MenuItemView!
    
    var item: MenuItem!
    
    func showItem() {
        itemView.set(productName: item.name)
        itemView.setImage(image: item.image)
        itemView.set(money: String(format: "$%.02f", item.price ?? 0))
    }
}
