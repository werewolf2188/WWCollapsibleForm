//
//  WWOptionViewRepresentation.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 10/2/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

public class WWOptionViewItem : NSObject {
    
    var optionView : UIView!
    
    public enum WWOptionViewItemSide : Int {
        case left
        case right
    }
    
    public var backgroundColor : UIColor? {
        didSet {
            self.optionView.backgroundColor = self.backgroundColor
        }
    }
    public var title : String! {
        didSet {
            if optionView is WWOptionButton {
                (optionView as? WWOptionButton)?.setTitle(self.title, for: .normal)
            }
            
        }
    }
    public var image : UIImage?
    {
        didSet {
            if optionView is WWOptionButton {
                (optionView as? WWOptionButton)?.setImage(self.image, for: .normal)
            }
            
        }
    }
    public var insets : UIEdgeInsets? {
        didSet {
            if optionView is WWOptionButton {
                (optionView as? WWOptionButton)?.setEdgeInsets()
            }
        }
    }
    public var padding : CGFloat = -1 {
        didSet {
            if self.padding > -1 {
                insets = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
            }
            if optionView is WWOptionButton {
                (optionView as? WWOptionButton)?.setEdgeInsets()
            }
        }
    }
    public var side : WWOptionViewItemSide = .right
    public var width : CGFloat = 0
    public var isIconCenterOverText : Bool = false {
        didSet {
            if optionView is WWOptionButton {
                if self.isIconCenterOverText {
                    (optionView as? WWOptionButton)?.centerIconOverText()
                } else {
                    (optionView as? WWOptionButton)?.resetEdgeInsets()
                }
            }
        }
    }
    public var tintColor : UIColor? {
        didSet {
            if optionView is WWOptionButton {
                (optionView as? WWOptionButton)?.setTintColor()
            }
        }
    }
    
    private func initialize(title: String, backgroundColor: UIColor? = nil, image : UIImage? = nil, insets : UIEdgeInsets?) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.image = image
        self.insets = insets
    }
    
    public init(title: String, backgroundColor: UIColor? = nil, image : UIImage? = nil, padding : CGFloat = -1) {
        super.init()
        var insets : UIEdgeInsets?
        if padding > -1 {
            self.padding = padding
            insets = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        }
        self.initialize(title: title, backgroundColor: backgroundColor, image: image, insets: insets)
    }

    public init(title: String, backgroundColor: UIColor? = nil, image : UIImage? = nil, insets : UIEdgeInsets?) {
        super.init()
        self.initialize(title: title, backgroundColor: backgroundColor, image: image, insets: insets)
    }
    
    public override var hash: Int {
        get {
            return ObjectIdentifier(self).hashValue
        }
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        if let otherObject = object as? WWOptionViewItem {
            return self.hash == otherObject.hash
        }
        return false
    }
    
    public func isEqual(to data: WWOptionViewItem) -> Bool {
        return self.isEqual(data)
    }
}

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
    
    func isAppExtension() -> Bool {
        return Bundle.main.executablePath?.contains(".appex/") ?? false
    }
    
    func isRTL() -> Bool {
        if #available(iOS 9.0, *) {
            return UIView.userInterfaceLayoutDirection(
                for: self.semanticContentAttribute) == .rightToLeft
        } else if self.isAppExtension() {
            return Locale.characterDirection(forLanguage: Locale.current.languageCode ?? "en-US") == .rightToLeft
        } else  {
            return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
        }
    }
}
