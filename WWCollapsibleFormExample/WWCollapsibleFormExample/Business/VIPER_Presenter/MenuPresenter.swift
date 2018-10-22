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
    func loadItem(item : MenuItemView, section: Int, data : WWDataObject)
    func itemSelected(section: Int, data : WWDataObject)
}

protocol MenuOutput : NSObjectProtocol {
    func getMenuSections(sections : [MenuSection])
}

class MenuPresenter : NSObject, MenuOutput, MenuViewEventHandler {
    weak var view: MenuView?
    var menuProvider : MenuProvider?
    static let BURGER_SECTION : Int = 0
    static let SIDES_SECTION : Int = 1
    static let BANKPRODUCT_SECTION : Int = 3
    
    // private section presenters
    private var sectionPresenters : [(section: Int, presenter: MenuHeaderViewPresenter)] = []
    //private row presenters
    private var rowPresenters : [(section: Int, data: WWDataObject, presenter: MenuItemViewPresenter)] = []
    
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
    
    func loadItem(item : MenuItemView, section: Int, data : WWDataObject) {
        if let holder = self.rowPresenters.filter({$0.section == section && $0.data == data}).first {
            holder.presenter.itemView = item
            holder.presenter.showItem()
        }
    }
    
    func itemSelected(section: Int, data : WWDataObject) {
        if let rHolder = self.rowPresenters.filter({$0.section == section && $0.data == data}).first,
            let sHolder = self.sectionPresenters.filter({$0.section == section}).first {
            if let parent = rHolder.data.parent,
                let rParentHolder = self.rowPresenters.filter({$0.data == parent}).first {
                sHolder.presenter.selectedItem = MenuItem(id: rParentHolder.presenter.item.id , name:
                        "\(rHolder.presenter.item.name ?? "") - \(rParentHolder.presenter.item.name ?? "")", image: rParentHolder.presenter.item.image, price: rHolder.presenter.item.price, children: nil)
            } else {
                sHolder.presenter.selectedItem = rHolder.presenter.item
            }
            
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
        if (sectionNum == MenuPresenter.BANKPRODUCT_SECTION) {
            section.unmutableOnceSelected = true
            let data = WWNonTemplateDataObject(view: AlternateCell())
            data.autoCollapse = false
            section.appendData(data: data)
            rowCount = 1
        }
        
        items.forEach { (item) in
            let data = item.children != nil &&
                (item.children?.count ?? 0) > 0 ? WWSubGroupDataObject(template: WWViewRepresentation(view: CellView()), headerTemplate : WWViewRepresentation(view: CellView())) : WWTemplateDataObject()
            let presenter : MenuItemPresenter = MenuItemPresenter()
            presenter.item = item
            
            //FOR TESTING
//            if (sectionNum == MenuPresenter.BURGER_SECTION && rowCount == 0) {
//                data.appendOptions(option: WWOptionViewItem(title: "Test1", backgroundColor: UIColor.blue, side: .left))
//                data.appendOptions(option: WWOptionViewItem(title: "Test2", backgroundColor: UIColor.red, side: .left))
//                data.appendOptions(option: WWOptionViewItem(title: "Test3", backgroundColor: UIColor.green, side: .left))
//                
//                data.appendOptions(option: WWOptionViewItem(title: "Test4", backgroundColor: UIColor.blue, side: .right))
//                
//                data.appendOptions(option: WWOptionViewItem(title: "Test6", backgroundColor: UIColor.green, side: .right))
//            }
            
            self.rowPresenters.append((section: sectionNum, data: data, presenter: presenter))
            rowCount = rowCount + 1            
            for children in item.children ?? [] {
                let childrenData = WWTemplateDataObject()
                let presenter : MenuItemPresenter = MenuItemPresenter()
                presenter.item = children
                self.rowPresenters.append((section: sectionNum, data: childrenData, presenter: presenter))
                rowCount = rowCount + 1
                (data as? WWSubGroupDataObject)?.appendData(object: childrenData)
            }
            section.appendData(data: data)
        }
        return section
    }
}
