//
//  UIButton_ActionHandleBlock.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/26/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
extension UIButton {
    
    private struct AssociatedKeys {
        static var ActionHandleBlock = "nsh_ActionHandleBlock"
    }
    
    var actionHandleBlock: (() -> Void)? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.ActionHandleBlock) as? () -> Void
        }
        
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(
                    self,
                    &AssociatedKeys.ActionHandleBlock,
                    newValue,
                    .OBJC_ASSOCIATION_RETAIN_NONATOMIC
                )
            }
        }
    }
    
    @objc private func triggerActionHandleBlock() {
        self.actionHandleBlock?()
    }
    
    func actionHandle(controlEvents control :UIControlEvents, forAction action:@escaping () -> Void) {
        self.actionHandleBlock = action
        self.addTarget(self, action: #selector(self.triggerActionHandleBlock), for: control)
    }
}
