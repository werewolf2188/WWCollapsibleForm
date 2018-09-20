//
//  MenuPresenter.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/20/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
import WWCollapsibleForm
protocol MenuViewEventHandler : NSObjectProtocol {
    var view: MenuView? { get set }
    var menuProvider : MenuProvider? { get set }
    func loadSections()
}

protocol MenuOutput : NSObjectProtocol {
    func getMenuSections(sections : [MenuSection])
}

class MenuPresenter : NSObject, MenuOutput, MenuViewEventHandler {
    weak var view: MenuView?
    var menuProvider : MenuProvider?
    
    func loadSections() {
        self.menuProvider?.provideMenuItems()
    }
    
    func getMenuSections(sections : [MenuSection])  {
        let wsections : [WWSection] = sections.map { (mSection) -> WWSection in
            self.getItemData(items: mSection.items)
        }
        
        
        self.view?.getSections(sections: wsections)
    }
    
    private func getItemData(items: [MenuItem]) -> WWSection {
        
        let section : WWSection = WWSection(header: WWViewRepresentation(headerView: Header()),
                                            template: WWViewRepresentation(view: CellView()),
                                            selectedHeader: WWViewRepresentation(headerView: SelectedHeader()))
        
        items.forEach { (item) in
            section.appendData(data: WWTemplateDataObject())
        }
        return section
    }
}
