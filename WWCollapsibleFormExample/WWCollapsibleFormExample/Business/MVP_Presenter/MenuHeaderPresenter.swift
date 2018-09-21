//
//  MenuHeaderPresenter.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/20/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
protocol MenuHeaderViewPresenter : NSObjectProtocol {
    var header: MenuHeaderView! { get set }
    var menuSection : MenuSection! { get set }
    var selectedItem : MenuItem? { get set }
    
    func showSection()
}

class MenuHeaderPresenter : NSObject, MenuHeaderViewPresenter {
    var header: MenuHeaderView!
    
    var menuSection: MenuSection!
    
    var selectedItem: MenuItem?
    
    func showSection() {
        self.header.set(title: self.menuSection.title)
        self.header.setSubtitle(title: self.menuSection.subtitle)
        
        if let selectedView = self.header as? MenuSelectedHeader,
            let selectedItem = selectedItem {
            selectedView.set(productName: selectedItem.name)
            selectedView.setImage(image: selectedItem.image)
            selectedView.set(money: String(format: "$%.02f", selectedItem.price ?? 0))
        }
    }
}
