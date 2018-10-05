//
//  WWSwipeViewInputOverlay.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 10/4/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
class WWSwipeViewInputOverlay : UIView {
    weak var currentView : WWSwipeView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initialize() {
        self.backgroundColor = UIColor.clear
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        
        if (event == nil) {
            return nil
        }
        if (currentView == nil) {
            self.removeFromSuperview()
            return nil
        }
        let p : CGPoint = self.convert(point, to: self.currentView)
        
        if (currentView != nil && (currentView.isHidden || currentView.bounds.contains(p))) {
            return nil
        }
        var hide : Bool = true
        if let delegate = self.currentView.delegate {
            hide = delegate.shouldHideSwipeOnTap(self.currentView, point: p)
        }
        
        if hide {
            self.currentView.hideSwipe(animated: true)
        }
        
        return self.currentView.touchOnDismissSwipe ? nil : self
    }
}
