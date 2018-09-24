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
    func loadHeader(header : MenuHeaderView, section : Int)
    func loadItem(item : MenuItemView, section: Int, row : Int)
    func itemSelected(section: Int, row : Int)
}

protocol MenuOutput : NSObjectProtocol {
    func getMenuSections(sections : [MenuSection])
}

class MenuPresenter : NSObject, MenuOutput, MenuViewEventHandler {
    weak var view: MenuView?
    var menuProvider : MenuProvider?
    static let BURGER_SECTION : Int = 0
    static let BANKPRODUCTO_SECTION : Int = 3
    
    // private section presenters
    private var sectionPresenters : [(section: Int, presenter: MenuHeaderViewPresenter)] = []
    //private row presenters
    private var rowPresenters : [(section: Int, row: Int, presenter: MenuItemViewPresenter)] = []
    
    func loadSections() {
        self.menuProvider?.provideMenuItems()
    }
    
    func getMenuSections(sections : [MenuSection])  {
        var sectionCount : Int = 0
        let wsections : [WWSection] = sections.map { (mSection) -> WWSection in
            let presenter : MenuHeaderPresenter = MenuHeaderPresenter()
            presenter.menuSection = mSection
            self.sectionPresenters.append((section: sectionCount, presenter: presenter))
            let section = self.getItemData(items: mSection.items, section: sectionCount)
            sectionCount = sectionCount + 1
            return section
        }
        self.view?.getSections(sections: wsections)
    }
    
    func loadHeader(header : MenuHeaderView, section : Int) {
        if let holder = self.sectionPresenters.filter({$0.section == section}).first {
            holder.presenter.header = header
            holder.presenter.showSection()
        }
    }
    
    func loadItem(item : MenuItemView, section: Int, row : Int) {
        if let holder = self.rowPresenters.filter({$0.section == section && $0.row == row}).first {
            holder.presenter.itemView = item
            holder.presenter.showItem()
        }
    }
    
    func itemSelected(section: Int, row : Int) {
        if let rHolder = self.rowPresenters.filter({$0.section == section && $0.row == row}).first,
            let sHolder = self.sectionPresenters.filter({$0.section == section}).first {
            sHolder.presenter.selectedItem = rHolder.presenter.item
        }
    }
    
    private func getItemData(items: [MenuItem], section sectionNum: Int) -> WWSection {
        let section : WWSection = WWSection(header: WWViewRepresentation(headerView: Header()),
                                            template: WWViewRepresentation(view: CellView()),
                                            selectedHeader: WWViewRepresentation(headerView: SelectedHeader()))
        
        if (sectionNum == MenuPresenter.BURGER_SECTION) {
            section.resetOnForward = true
        }
        var rowCount : Int = 0
        if (sectionNum == MenuPresenter.BANKPRODUCTO_SECTION) {
            section.unmutableOnceSelected = true
            let data = WWNonTemplateDataObject(view: AlternateCell())
            data.autoCollapse = false
            section.appendData(data: data)
            rowCount = 1
        }
        
        items.forEach { (item) in
            let data = WWTemplateDataObject()
            let presenter : MenuItemPresenter = MenuItemPresenter()
            presenter.item = item
            self.rowPresenters.append((section: sectionNum, row: rowCount, presenter: presenter))
            rowCount = rowCount + 1
            section.appendData(data: data)
        }
        return section
    }
}
