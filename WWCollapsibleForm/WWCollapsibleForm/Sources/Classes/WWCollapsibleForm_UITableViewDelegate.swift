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
        let header : UIView = self.sections[section].getHeader()
        (header as? WWHeaderFooterView)?.reference = self
        (header as? WWHeaderFooterView)?.section = section
        return header
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer : UIView? = self.sections[section].getFooter()
        (footer as? WWHeaderFooterView)?.reference = self
        (footer as? WWHeaderFooterView)?.section = section
        return footer ?? UIView(frame: CGRect.zero)
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.sections[section].header?.height ?? UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (self.sections[section].status != .selected) {
            return self.sections[section].footer?.height ?? minimumFooterHeight
        }
        return 1
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.sections[indexPath.section].getHeight(row: indexPath.row)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
        if (self.sections[indexPath.section].data[indexPath.row].autoCollapse) {
            self.collapse(indexPath: indexPath)
        }
    }
}
