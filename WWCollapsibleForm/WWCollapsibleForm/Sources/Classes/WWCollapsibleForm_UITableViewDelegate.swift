//
//  WWCollapsibleForm_UITableViewDelegate.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
extension WWCollapsibleForm : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /// optimize
        self.sections[indexPath.section].addView(form: self, cell: cell, row: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header : UIView = self.sections[section].getHeader(section: section, form: self)
        return header
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer : UIView? = self.sections[section].getFooter(section: section, form: self)
        return footer ?? UIView(frame: CGRect.zero)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.sections[section].header?.height ?? UITableViewAutomaticDimension // Improve
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (self.sections[section].status != .selected) {
            return self.sections[section].footer?.height ?? minimumFooterHeight // Improve
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
