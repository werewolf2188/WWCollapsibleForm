//
//  WWCollapsibleForm_Collapsible.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
extension WWCollapsibleForm {
    
    private func scrollAndEnable(nextSection: Int) {
        //The scroll is doing a weird bounce effect.
//        self.scrollToRow(at: IndexPath(row: 0, section: nextSection), at: .top, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + CATransaction.animationDuration(), execute: {
            self.sections[nextSection].status = .enabled
            self.tableView.reloadSections([nextSection], with: .none)
        })
    }
    
    func collapse(indexPath: IndexPath) {
        self.collapse(section: indexPath.section)
    }
    
    public func collapse(section : Int) {
        self.collapseDelegate?.willCollapse(section: section, form: self)
        CATransaction.begin()
        self.tableView.beginUpdates()
        CATransaction.setCompletionBlock {
            let nextSection = section + 1
            if (nextSection < self.sections.count
                && self.sections[nextSection].status == .disabled) {
                self.scrollAndEnable(nextSection: nextSection)
                self.collapseDelegate?.didCollapse(section: section, form: self)
            } else {
                if self.footer != nil {
                    self.footerContainer.move(show: true, animated: self.configuration.animateFooter)
                    //BUG HERE
                    let bottomOffset : CGPoint = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.bounds.size.height - self.footerContainer.getHeight() / 2)
                    self.tableView.setContentOffset(bottomOffset, animated: self.configuration.animateFooter)
                    //
                }               
            }
        }
        self.sections[section].status = .selected
        self.tableView.reloadSections([section], with: .fade)
        self.tableView.endUpdates()
        CATransaction.commit()
    }
    
    func expand(indexPath: IndexPath) {
        self.expand(section: indexPath.section)
    }
    
    public func expand(section : Int) {
        self.collapseDelegate?.willExpand(section: section, form: self)
        if self.footer != nil && self.footerContainer.isOnScreen {
            self.footerContainer.move(show: false, animated: self.configuration.animateFooter)
        }
        
        CATransaction.begin()
        self.tableView.beginUpdates()
        CATransaction.setCompletionBlock {
            if self.sections[section].resetOnForward {
                var indexes : [Int] = []
                for index in (section + 1)..<self.sections.count {
                    if (self.sections[index].status == .enabled ||
                        (self.sections[index].status == .selected && !self.sections[index].unmutableOnceSelected )) {
                        self.sections[index].status = .disabled
                        indexes.append(index)
                    }
                }
                let indexSet : IndexSet = IndexSet(indexes)
                self.tableView.reloadSections(indexSet, with: .none)
            }
        }
        self.sections[section].status = .enabled
        self.tableView.reloadSections([section], with: .fade)
        self.tableView.endUpdates()
        CATransaction.commit()
        
        self.collapseDelegate?.didExpand(section: section, form: self)
    }
}
