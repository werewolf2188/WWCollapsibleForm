//
//  WWCollapsibleForm_UITableViewDelegate.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
extension WWCollapsibleForm : UITableViewDelegate {
    
    internal func getTopSelectedIndex() -> Int {
        return self.sections.filter({$0.status == .selected}).sorted { (sectionA, sectionB) -> Bool in
            return sectionA.section > sectionB.section
            }.first?.section ?? -1
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /// optimize
        
        if let view = self.sections[indexPath.section].addView(form: self, cell: cell, row: indexPath.row) {
            self.formDelegate?.modifyItem(item: view, indexPath: indexPath)
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header : UIView = self.sections[section].getHeader(section: section, form: self)
        if (self.sections[section].status == .selected) {
            if section == self.getTopSelectedIndex() {
                header.drawDiagonal(draw: true, section: section, maxSection: self.sections.count, color: UIColor.white)
            }
            
            for index in 0..<self.sections.count {
                if (self.sections[index].section != self.getTopSelectedIndex()
                    && (index < self.sections.count - 1 && self.sections[index + 1].status == .selected)) {
                    self.sections[index].addSeparatorToSelectedHeader()
                }
            }
        } else if (self.sections[section].status == .enabled && section > 0) {
            self.sections[section - 1].removeSeparatorToSelectedHeader { (selectedHeader, sectionIndex) in
                if sectionIndex == self.getTopSelectedIndex() {
                    selectedHeader.drawDiagonal(draw: true, section: sectionIndex, maxSection: self.sections.count, color: UIColor.white)
                }
            }
        }
        self.formDelegate?.modifyHeader(header: header, section: section)
        return header
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (self.sections[section].status != .selected) {
            let footer : UIView = UIView()
            footer.backgroundColor = self.sections[section].getHeader(section: section, form: self).backgroundColor
            return footer
        }
        return nil
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (self.sections[section].status == .selected) {
            return self.sections[section].selectedHeader?.height ?? UITableViewAutomaticDimension // Improve
        }
        return self.sections[section].header?.height ?? UITableViewAutomaticDimension // Improve
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (self.sections[section].status != .selected) {
            return minimumFooterHeight 
        }
        return 0.000001 //Well it worked
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.sections[indexPath.section].getHeight(row: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.sections[indexPath.section].shouldAutoCollapse(row: indexPath.row)) {
            self.formDelegate?.itemSelected(indexPath: indexPath)
            self.collapse(indexPath: indexPath)
        }
    }
}
