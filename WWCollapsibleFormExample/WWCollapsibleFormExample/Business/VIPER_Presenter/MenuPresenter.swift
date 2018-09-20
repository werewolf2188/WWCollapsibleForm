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
    func loadSections()
}

class MenuPresenter : NSObject, MenuViewEventHandler {
    weak var view: MenuView?
    var menuProvider : MenuProvider!
    
    func loadSections() {
        var sections : [WWSection] = []
        sections.append(self.getCreditCartSections())
        sections.append(self.getCreditCartSections())
        sections.append(self.getCreditCartSections())
        sections.append(self.getCreditCartSections())
        sections.append(self.getCreditCartSections())
        self.view?.getSections(sections: sections)
    }
    
    private func getCreditCartSections() -> WWSection {
        
        let section : WWSection = WWSection(header: WWViewRepresentation(headerView: Header()),
                                            template: WWViewRepresentation(view: CellView()),
                                            selectedHeader: WWViewRepresentation(headerView: SelectedHeader()))
        
        section.appendData(data: WWTemplateDataObject())
        section.appendData(data: WWTemplateDataObject())
        return section
    }
}
