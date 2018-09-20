//
//  WWCollapsibleForm_UITableViewDelegate.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
extension WWCollapsibleForm : UITableViewDelegate {
    
    internal func getCurrentSelectedIndex() -> Int {
        return self.sections.filter({$0.status == .selected }).count - 1
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /// optimize
        self.sections[indexPath.section].addView(form: self, cell: cell, row: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header : UIView = self.sections[section].getHeader(section: section, form: self)
        if (self.sections[section].status == .selected) {
            if section == self.getCurrentSelectedIndex() {
                header.drawDiagonal(draw: true, section: section, maxSection: self.sections.count, color: UIColor.white)
            }
            if (section > 0) {
                let lastView = self.sections[section - 1].getHeader(section: section, form: self)
                lastView.removeDiagonal()
                UIView.addSeparator(subView: lastView, color: UIColor.white)
            }
        }
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
            self.collapse(indexPath: indexPath)
        }
    }
}
