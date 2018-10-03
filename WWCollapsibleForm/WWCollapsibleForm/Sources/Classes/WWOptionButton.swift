//
//  WWOptionButton.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 10/3/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

class WWOptionButton: UIButton {
    
    var option : WWOptionViewItem!
    
    var tempTitleEdgeInsets : UIEdgeInsets!
    var tempImageEdgeInsets : UIEdgeInsets!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init(option: WWOptionViewItem) {
        self.init(type: .custom)
        self.option = option
        self.option.optionView = self
        self.backgroundColor = self.option.backgroundColor
        self.titleLabel?.lineBreakMode = .byWordWrapping
        self.titleLabel?.textAlignment = .center
        self.setTitle(self.option.title, for: .normal)
        self.setTitleColor(UIColor.white, for: .normal)
        self.setImage(self.option.image, for: .normal)
        self.tempImageEdgeInsets = self.imageEdgeInsets
        self.tempTitleEdgeInsets = self.titleEdgeInsets
        self.setEdgeInsets()
    }
    
    func setEdgeInsets(){
        if let insets = self.option.insets {
            self.contentEdgeInsets = insets
            self.sizeToFit()
        }
    }
    
    func resetEdgeInsets() {
        self.imageEdgeInsets = self.tempImageEdgeInsets
        self.titleEdgeInsets = self.tempTitleEdgeInsets
    }
    
    func centerIconOverText(with spacing: CGFloat = 3.0) {
        if let size = self.imageView?.image?.size {
            if (Double(UIDevice.current.systemVersion) ?? 0) > 9.0 && self.isRTL() {
                self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: -(size.height + spacing), right: -size.width)
                let titleSize = (self.titleLabel?.text as NSString?)?.size(withAttributes: [NSAttributedStringKey.font   : self.titleLabel?.font ?? UIFont.systemFont(ofSize: self.titleLabel?.font.pointSize ?? 8)]) ?? CGSize.zero
                self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: -titleSize.width, bottom: 0.0, right: 0.0)
            } else {
                self.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: -size.width, bottom: -(size.height + spacing), right: 0.0)
                let titleSize = (self.titleLabel?.text as NSString?)?.size(withAttributes: [NSAttributedStringKey.font   : self.titleLabel?.font ?? UIFont.systemFont(ofSize: self.titleLabel?.font.pointSize ?? 8)]) ?? CGSize.zero
                self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
            }
        }
    }
    
    func setButtonWidth() {
        /*
         _buttonWidth = buttonWidth;
         if (_buttonWidth > 0)
         {
         CGRect frame = self.frame;
         frame.size.width = _buttonWidth;
         self.frame = frame;
         }
         else
         {
         [self sizeToFit];
         }
         */
    }
    
    func setTintColor() {
        if let tintColor = self.option.tintColor {
            var currentIcon = self.imageView?.image
            if currentIcon?.renderingMode != UIImageRenderingMode.alwaysOriginal {
                currentIcon = currentIcon?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
                self.setImage(self.option.image, for: .normal)
            }
            self.tintColor = tintColor
        }        
    }
}
