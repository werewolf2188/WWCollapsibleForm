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
    
    func addSubViewWithConstraints(_ subView:UIView) {
        self.addSubview(subView)
        subView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        subView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        subView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        subView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    //Will change
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
            separator.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: leading * -1 ).isActive = true
        } else {
            separator.trailingAnchor.constraint(equalTo: subView.trailingAnchor, constant: (trailing > 0 ? trailing * -1 : trailing)).isActive = true
        }
        separator.bottomAnchor.constraint(equalTo: subView.bottomAnchor, constant: -1).isActive = true
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    //Will change
    func hideSeparator(draw:Bool, section: Int, maxSection: Int)
    {
        let selfV : UIView = self
        let separator : UIView? = selfV.viewWithTag(999)
        separator?.isHidden = draw && (section + 1) < maxSection
        
    }
    //Will change
    func removeDiagonal() {
        
        var shapeLayer : CAShapeLayer?
        
        if let sublayers = self.layer.sublayers,
            (sublayers.count > 0) {
            shapeLayer = sublayers.filter({$0.name == self.diagonalName}).first as? CAShapeLayer
            shapeLayer?.removeFromSuperlayer()
        }
    }

    //Will change
    func drawDiagonal(draw:Bool, section: Int, maxSection: Int, color: UIColor)
    {
        
        let selfV : UIView = self
        self.hideSeparator(draw: draw, section: section, maxSection: maxSection)
        
        var shapeLayer : CAShapeLayer?
        let layerMinusHeight : CGFloat = 20
        
        shapeLayer = CAShapeLayer()
        shapeLayer?.name = self.diagonalName
        let path : CGMutablePath = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: selfV.bounds.height))
        path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: selfV.bounds.height))
        path.addLine(to: CGPoint(x: UIScreen.main.bounds.width, y: selfV.bounds.height - layerMinusHeight))
        path.closeSubpath()
        shapeLayer?.path = path
        shapeLayer?.fillColor = color.cgColor
        if let newLayer = shapeLayer,
            (draw && (section + 1) < maxSection)
        {
            selfV.layer.addSublayer(newLayer)
        }
        
    }
}
