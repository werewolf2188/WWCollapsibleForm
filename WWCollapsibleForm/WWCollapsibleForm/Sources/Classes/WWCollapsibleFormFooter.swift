//
//  WWCollapsibleFormFooter.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 10/22/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
class WWCollapsibleFormFooter : UIView {
    
    private var leadingC : NSLayoutConstraint!
    private var trailingC: NSLayoutConstraint!
    private var bottomC: NSLayoutConstraint!
    private var heightC: NSLayoutConstraint!
    private var didSetupConstraints = false
    private var subFooter : UIView!
    internal var isOnScreen : Bool = false
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(subView: UIView, superView: UIView) {
        self.init(frame: CGRect(x: 0, y: UIScreen.main.bounds.height + subView.frame.height, width: UIScreen.main.bounds.width, height: subView.frame.height))
        self.subFooter = subView
        superView.addSubview(self)
    }
    
    private func addConstraints()
    {
        if let supVi = self.superview, !self.didSetupConstraints
        {
            self.leadingC = self.leadingAnchor.constraint(equalTo: supVi.leadingAnchor, constant: 0)
            self.trailingC = self.trailingAnchor.constraint(equalTo: supVi.trailingAnchor, constant: 0)
            self.bottomC = self.bottomAnchor.constraint(equalTo: supVi.bottomAnchor, constant: self.subFooter.frame.height)
            self.heightC = self.heightAnchor.constraint(equalToConstant: self.subFooter.frame.height)
            
            self.leadingC.isActive = true
            self.trailingC.isActive = true
            self.bottomC.isActive = true
            self.heightC.isActive = true
            self.didSetupConstraints = true
            self.addSubViewWithConstraints(self.subFooter)
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.addConstraints()
    }
    
    func move(show: Bool, animated: Bool = true) {
        if show && !self.isOnScreen{
            self.isOnScreen = true
            self.bottomC.constant = 0
        } else if !show && self.isOnScreen {
            self.isOnScreen = false
            self.bottomC.constant = self.subFooter.frame.height
        } else {
            return
        }
        
        if (animated) {
            UIView.animate(withDuration: CATransaction.animationDuration(), animations: {
                self.superview?.layoutIfNeeded()
            })
        }
        else {
            self.superview?.layoutIfNeeded()
        }
    }
}
