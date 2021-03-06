//
//  WWItemView.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
/// This class helps views to be configured as item of a data object. It gives the basic functionality of what a view can
/// do. Data object does not have to related to a subclass of this class, but it will definetily help.
open class WWItemView : UIView, WWStatusApplier {
    
    private var _subGroupButton : UIButton?
    
    internal var reference: WWCollapsibleForm!
    internal var indexPath: IndexPath!
    
    /// The decorator that will be applied when a section is enabled.
    public var enableDecorator: WWStatusDecorator?
    /// The decorator that will be applied when a section is disabled.
    public var disableDecorator: WWStatusDecorator?
    /// If a view becomes the header of a group, this button will be instantiated and it will become useful for modifications
    public var subGroupButton : UIButton? { get { return _subGroupButton } }
    
    /// If a view becomes the header of a group, the `subGroupButton` property will be instantiated and it will become useful for modifications. This image will be used when the sub groups collapses.
    public var collapseImage : UIImage?
    /// If a view becomes the header of a group, the `subGroupButton` property will be instantiated and it will become useful for modifications. This image will be used when the sub groups expands.
    public var expandImage : UIImage?
    
    /// If a view becomes the header of a group, the `subGroupButton` property will be instantiated and it will become useful for modifications. If true, the sub group will collapse, but it is false, it will expand.
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
    
    /// Allows an item to collapse its section.
    public func collapse() {
        self.reference.collapse(indexPath: indexPath)
    }
}

extension WWItemView : WWSwipeViewDelegate {
    func canSwipe(_ swipeView: WWSwipeView, direction: WWSwipeViewDirection, from point: CGPoint) -> Bool? {
        return nil
    }
    
    func canSwipe(_ swipeView: WWSwipeView, direction: WWSwipeViewDirection) -> Bool? {
        return nil
    }
    
    func didChangeSwipeState(_ swipeView: WWSwipeView, state: WWSwipeViewState, isGestureActive: Bool) {
        
    }
    
    func tappedButtonAtIndex(_ swipeView: WWSwipeView, index: Int, direction: WWSwipeViewDirection, fromExpansion: Bool) -> Bool {
        let section : WWSection = self.reference.sections[self.indexPath.section]
        let dataObject : WWDataObject = section.getDataObject(row: self.indexPath.row)
        let option : WWOptionViewItem =  dataObject.options.filter({ $0.side.rawValue == direction.rawValue})[index]
        if option != dataObject.deleteOption {
            reference.formDelegate?.optionSelected?(option: option, data: dataObject, section: self.indexPath.section)
        } else {
            section.removeItem(form: self.reference, indexPath: self.indexPath, dataObject: dataObject)
        }
        return true
    }
    
    func canSwipe(_ swipeView: WWSwipeView, direction: WWSwipeViewDirection, setting: WWSwipeViewSettings, expansionSettings: WWSwipeViewExpansionSettings) -> [UIView]? {
        return nil
    }
    
    func shouldHideSwipeOnTap(_ swipeView: WWSwipeView, point: CGPoint) -> Bool {
        return true
    }
    
    func swipeTableCellWillBeginSwiping(_ swipeView: WWSwipeView) {
        
    }
    
    func swipeTableCellWillEndSwiping(_ swipeView: WWSwipeView) {
        
    }
}
