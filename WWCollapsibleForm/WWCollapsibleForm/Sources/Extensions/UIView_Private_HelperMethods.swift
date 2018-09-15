//
//  UIView_Private_HelperMethods.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 9/14/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

extension UIView {
    func addSubViewWithConstraints(_ subView:UIView) {
        self.addSubview(subView)
        subView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        subView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        subView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        subView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    class func addSeparator(subView: UIView, color: UIColor = UIColor.black, leading: CGFloat = 30, trailing: CGFloat = CGFloat.nan) {
        let tag : Int = 999
        subView.viewWithTag(tag)?.removeFromSuperview()
        let separator : UIView = UIView(frame: CGRect.zero)
        separator.tag = tag
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = color
        subView.addSubview(separator)
        separator.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: leading).isActive = true
        if String(describing: CGFloat.nan) == String(describing: trailing) {
            separator.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: leading * -2 ).isActive = true
        } else {
            separator.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: (trailing > 0 ? trailing * -1 : trailing)).isActive = true
        }
        separator.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: -1).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
