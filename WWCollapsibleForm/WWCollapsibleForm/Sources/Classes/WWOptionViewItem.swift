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
            if self.backgroundColor != nil {
                self.optionView.backgroundColor = self.backgroundColor
            }
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
    
    func getView() -> UIView {
        return WWOptionButton(option: self)
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
