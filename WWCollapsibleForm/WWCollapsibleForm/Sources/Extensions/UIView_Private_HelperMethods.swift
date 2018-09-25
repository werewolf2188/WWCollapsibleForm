//
//  UIView_Private_HelperMethods.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 9/14/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

extension UIView {
    
    private var diagonalName : String {
        get {
            return "diagonal"
        }
    }
    
    private static var specialTag : Int {
        get {
            return 999
        }
    }
    
    private var specialTag : Int {
        get {
            return UIView.specialTag
        }
    }
    
    
    func addSubViewWithConstraints(_ subView:UIView, edgeInsets : UIEdgeInsets = UIEdgeInsets.zero) {
        self.addSubview(subView)
        
        subView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: edgeInsets.left).isActive = true
        subView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: edgeInsets.right).isActive = true
        subView.topAnchor.constraint(equalTo: self.topAnchor, constant: edgeInsets.top).isActive = true
        subView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: edgeInsets.bottom).isActive = true
        subView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //Will change
    class func addSeparator(subView: UIView, color: UIColor = UIColor.black, leading: CGFloat = 30, trailing: CGFloat = CGFloat.nan) {
        let tag : Int = UIView.specialTag
        subView.viewWithTag(tag)?.removeFromSuperview()
        let separator : UIView = UIView(frame: CGRect.zero)
        separator.tag = tag
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = color
        subView.addSubview(separator)
        separator.leadingAnchor.constraint(equalTo: subView.leadingAnchor, constant: leading).isActive = true
        if String(describing: CGFloat.nan) == String(describing: trailing) {
            separator.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: leading * -1 ).isActive = true
        } else {
            separator.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: (trailing > 0 ? trailing * -1 : trailing)).isActive = true
        }
        separator.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: -1).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    //Will change
    func removeSeparator()
    {
        let selfV : UIView = self
        let separator : UIView? = selfV.viewWithTag(self.specialTag)
        separator?.removeFromSuperview()
    }
    //Will change
    func removeDiagonal() {
        if let sublayers = self.layer.sublayers,
            (sublayers.count > 0) {
            sublayers.filter({$0.name == self.diagonalName}).first?.removeFromSuperlayer()
        }
    }

    //Will change
    func drawDiagonal(draw:Bool, section: Int, maxSection: Int, color: UIColor) {
        var shapeLayer : CAShapeLayer
        let layerMinusHeight : CGFloat = 20
        
        self.removeSeparator()
        
        if let sublayers = self.layer.sublayers,
            (sublayers.filter({$0.name == self.diagonalName}).count > 0) {
            return
        }
        
        shapeLayer = CAShapeLayer()
        shapeLayer.name = self.diagonalName
        let path : CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: self.bounds.height))
        path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: self.bounds.height))
        path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: self.bounds.height - layerMinusHeight))
        path.closeSubpath()
        shapeLayer.path = path
        shapeLayer.fillColor = color.cgColor
        if (draw && (section + 1) < maxSection) {
            self.layer.addSublayer(shapeLayer)
        }
    }
}
