//
//  WWCollapsibleForm_Collapsible.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
extension WWCollapsibleForm {
    func collapse(indexPath: IndexPath) {
        self.collapse(section: indexPath.section)
    }
    
    func collapse(section : Int) {
        self.sections[section].status = .selected
        self.reloadSections([section], with: .fade)
    }
    
    func expand(indexPath: IndexPath) {
        self.expand(section: indexPath.section)
    }
    
    func expand(section : Int) {
        self.sections[section].status = .enabled
        self.reloadSections([section], with: .fade)
    }
}
