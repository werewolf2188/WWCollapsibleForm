//
//  WWOptionViewRepresentation.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 10/2/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

/// This class represents an option for an item. The options can be set in the right or the left side of the item, depending where the swipe starts from. This object will only represent the final view used inside the option container, its not a view.
public class WWOptionViewItem : NSObject {
    
    var optionView : UIView!
    
    /// This enumerator will be used to set up the side in where the option will be rendered.
    public enum WWOptionViewItemSide : Int {
        /// The option will appear in the left side of the item and it will need a left swipe.
        case left
        /// The option will appear in the right side of the item and it will need a right swipe.
        case right
    }
    
    /// The background color of the option.
    public var backgroundColor : UIColor? {
        didSet {
            if self.backgroundColor != nil && optionView != nil{
                self.optionView.backgroundColor = self.backgroundColor
            }
            
        }
    }
    
    /// The title of the option.
    public var title : String! {
        didSet {
            if optionView is WWOptionButton {
                (optionView as? WWOptionButton)?.setTitle(self.title, for: .normal)
            }
            
        }
    }
    
    /// The image of the option.
    public var image : UIImage?
    {
        didSet {
            if optionView is WWOptionButton {
                (optionView as? WWOptionButton)?.setImage(self.image, for: .normal)
            }
            
        }
    }
    
    /// The insets of the option. It will be better to use the padding rather than this property.
    public var insets : UIEdgeInsets? {
        didSet {
            if optionView is WWOptionButton {
                (optionView as? WWOptionButton)?.setEdgeInsets()
            }
        }
    }
    
    /// The padding between the image and the text between its option container. Default: no padding.
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
    /// The side where the option will appear. Default: right.
    public var side : WWOptionViewItemSide = .right
    /// The width of the option. By default, it takes the widht of the inner text.
    public var width : CGFloat = 0
    /// Set this to true if the text and the imager should be center or false if it should be at the default insets.
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
    
    /// The tint color of the option.
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
    
    private func initialize(title: String, backgroundColor: UIColor? = UIColor.blue, image : UIImage? = nil, insets : UIEdgeInsets?, side: WWOptionViewItemSide) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.image = image
        self.insets = insets
        self.side = side
    }
    
    /// Intializer used to create an option. Use this one instead of the one with the edge insets parameter.
    /// - Parameters:
    ///     - title: The title of the option.
    ///     - backgroundColor: The color of the background of the option. Default: blue.
    ///     - image: The image related to this option. Default: nil.
    ///     - padding: The padding between the text and the container view. Default: no padding.
    ///     - side: The side where the option will appear. Default: right.
    public init(title: String, backgroundColor: UIColor? = UIColor.blue, image : UIImage? = nil, padding : CGFloat = -1, side: WWOptionViewItemSide = .right) {
        super.init()
        var insets : UIEdgeInsets?
        if padding > -1 {
            self.padding = padding
            insets = UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
        }
        self.initialize(title: title, backgroundColor: backgroundColor, image: image, insets: insets, side: side)
    }

    /// Intializer used to create an option.
    /// - Parameters:
    ///     - title: The title of the option.
    ///     - backgroundColor: The color of the background of the option. Default: blue.
    ///     - image: The image related to this option. Default: nil.
    ///     - insets: The insets of the inner controls. Default: nil.
    ///     - side: The side where the option will appear. Default: right.
    public init(title: String, backgroundColor: UIColor? = nil, image : UIImage? = nil, insets : UIEdgeInsets?, side: WWOptionViewItemSide = .right) {
        super.init()
        self.initialize(title: title, backgroundColor: backgroundColor, image: image, insets: insets, side: side)
    }
    
    /// Retrieve a hash value that represents this object.
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
    
    /// Returns a Boolean value that indicates whether the receiver and a given object are equal.
    /// This method defines what it means for instances to be equal. For example, a container object might define two containers as equal if their corresponding objects all respond true to an isEqual(_:) request. See the NSData, NSDictionary, NSArray, and NSString class specifications for examples of the use of this method.
    /// - Remark: If two objects are equal, they must have the same hash value. This last point is particularly important if you define isEqual(_:) in a subclass and intend to put instances of that subclass into a collection. Make sure you also define hash in your subclass.
    /// - Parameter data: The object to be compared to the receiver.
    /// - Returns: true if the receiver and anObject are equal, otherwise false.
    public func isEqual(to data: WWOptionViewItem) -> Bool {
        return self.isEqual(data)
    }
}
