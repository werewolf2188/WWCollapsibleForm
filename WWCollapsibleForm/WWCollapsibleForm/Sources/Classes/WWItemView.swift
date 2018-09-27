//
//  WWItemView.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
open class WWItemView : UIView, WWStatusApplier {
    
    private var _subGroupButton : UIButton?
    
    internal var reference: WWCollapsibleForm!
    internal var indexPath: IndexPath!
    
    public var enableDecorator: WWStatusDecorator?
    public var disableDecorator: WWStatusDecorator?
    public var subGroupButton : UIButton? { get { return _subGroupButton } }
    
    public var collapseImage : UIImage?
    public var expandImage : UIImage?
    
    public var isCollapsed : Bool! {
        didSet {
            if (self.isCollapsed){
                if (collapseImage != nil){
                    _subGroupButton?.setImage(collapseImage, for: .normal)
                } else {
                    _subGroupButton?.setTitle("▼", for: .normal)
                }
            } else {
                if (expandImage != nil){
                    _subGroupButton?.setImage(expandImage, for: .normal)
                } else {
                    _subGroupButton?.setTitle("▲", for: .normal)
                }
            }
        }
    }
    
    internal func buildSubGroupButton() {
        
        if _subGroupButton == nil {
            _subGroupButton = UIButton(type: .custom)
            _subGroupButton?.setTitle("▼", for: .normal)
            if let _subGroupButton = _subGroupButton {
                self.addSubview(_subGroupButton)
                //This should be based on configuration later on
                _subGroupButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
                _subGroupButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
                _subGroupButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
                _subGroupButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
                _subGroupButton.translatesAutoresizingMaskIntoConstraints = false
            }
            
        }
    }
    
    public func collapse() {
        self.reference.collapse(indexPath: indexPath)
    }
}
