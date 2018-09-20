//
//  MenuInteractor.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/20/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

protocol MenuProvider : NSObjectProtocol {
    var context: IUnitOfWork? { get set }
    var output: MenuOutput? { get set }
    
    func provideMenuItems()
}

class MenuInteractor: NSObject, MenuProvider {
    var context: IUnitOfWork?
    var output: MenuOutput?
    
    func provideMenuItems() {
        if let context = context {
            self.output?.getMenuSections(sections: [
                    self.getAsItems(singleSizeProducts: context.database.menu.combos, title: "Combos"),
                    self.getAsItems(multipleSizeProducts: context.database.menu.sides, title: "Sides"),
                    self.getAsItems(singleSizeProducts: context.database.menu.desserts, title: "Desserts"),
                    self.getAsItems(bankProduct: context.database.user.accounts, title: "User", subtitle: context.database.user.name),
                ])
        }
    }
    
    private func getAsItems(singleSizeProducts: [SingleSizeProduct],title: String , subtitle:String? = nil) -> MenuSection {
        let items : [MenuItem] = singleSizeProducts.map { (product) -> MenuItem in
            MenuItem(id: product.id, name: product.name, image: product.image, price: product.price, children: [])
        }
        let menuSection : MenuSection = MenuSection(title: title, subtitle: subtitle, items: items)
        return menuSection
    }
    
    private func getAsItems(bankProduct: [BankProduct],title: String , subtitle:String? = nil) -> MenuSection {
        let items : [MenuItem] = bankProduct.map { (product) -> MenuItem in
            MenuItem(id: "\(product.id)|\(product.type.rawValue)" , name: product.name, image: product.image, price: product.balance, children: [])
        }
        let menuSection : MenuSection = MenuSection(title: title, subtitle: subtitle, items: items)
        return menuSection
    }
    
    private func getAsItems(multipleSizeProducts: [MultipleSizeProduct],title: String, subtitle:String? = nil) -> MenuSection {
        let items : [MenuItem] = multipleSizeProducts.map { (product) -> MenuItem in
            MenuItem(id: product.id, name: product.name, image: product.image, price: nil, children:
                product.children.map({ (pSize) -> MenuItem in
                    MenuItem(id: pSize.id, name: pSize.name, image: nil, price: pSize.price, children:nil)
                })
            )
        }
        
        let menuSection : MenuSection = MenuSection(title: title, subtitle: subtitle, items: items)
        return menuSection
    }
    
    
}
