//
//  WWCollapsibleForm_UITableViewDelegate.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
extension WWCollapsibleFormAdapter : UITableViewDelegate {
    
    internal func getTopSelectedIndex() -> Int {
        return self.sections.filter({$0.status == .selected}).sorted { (sectionA, sectionB) -> Bool in
            return sectionA.section > sectionB.section
            }.first?.section ?? -1
    }
    
    internal func areAllSelected() -> Bool {
        return self.sections.filter({$0.status == .selected}).count == self.sections.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let view = self.sections[indexPath.section].addView(form: self.publicForm, cell: cell, row: indexPath.row) {
            self.formDelegate?.modifyItem(item: view, data: self.sections[indexPath.section].getDataObject(row: indexPath.row), section: indexPath.section)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header : UIView = self.sections[section].getHeader(section: section, form: self.publicForm)
        (header as? WWHeaderView)?.applyStatus(status: self.sections[section].status)
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if (self.sections[section].status != .selected) {
            let footer : UIView = UIView()
            footer.backgroundColor = self.sections[section].getHeader(section: section, form: self.publicForm).backgroundColor
            return footer
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (self.sections[section].status == .selected) {
            
            if (self.areAllSelected() && self.publicForm.footer != nil && section == self.sections.count - 1
                && self.sections[section].selectedHeader?.height != nil
                && self.sections[section].selectedHeader?.height != UITableViewAutomaticDimension) {
                return ((self.sections[section].selectedHeader?.height ?? 0) + self.publicForm.footerContainer.getHeight())
            }
            return self.sections[section].selectedHeader?.height ?? UITableViewAutomaticDimension // Improve
        }
        return self.sections[section].header?.height ?? UITableViewAutomaticDimension // Improve
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (self.sections[section].status != .selected) {
            return minimumFooterHeight 
        }
        return 0.000001 //Well it worked
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.sections[indexPath.section].getHeight(row: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (self.sections[indexPath.section].shouldAutoCollapse(row: indexPath.row)) {
            self.formDelegate?.itemSelected(data: self.sections[indexPath.section].getDataObject(row: indexPath.row), section: indexPath.section)
            self.publicForm.collapse(indexPath: indexPath)
        } else if (self.sections[indexPath.section].isParentAndEnabled(row: indexPath.row)),
            let items = self.sections[indexPath.section].changeSubGroup(row: indexPath.row) {
            self.tableView.beginUpdates()
            self.tableView.reloadRows(at:  [indexPath], with: .none)
            self.tableView.reloadRows(at: items, with: .bottom)
            self.tableView.endUpdates()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (self.areAllSelected() && self.publicForm.footer != nil) {
            let velocity : CGPoint = self.tableView.panGestureRecognizer.velocity(in: self.publicForm)
            if velocity.y < 0 && !self.publicForm.footerContainer.isOnScreen {
                self.publicForm.footerContainer.move(show: true)
            }
            else if velocity.y > 0 && self.publicForm.footerContainer.isOnScreen {
                self.publicForm.footerContainer.move(show: false)
            }
        }
        
    }
}
