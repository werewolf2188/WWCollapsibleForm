//
//  WWDataObject.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

protocol WWAutoCollapsable : NSObjectProtocol {
    var autoCollapse : Bool { get set }
}

/// A data object represents an item that can be shown in a section, and it will be related to a piece of data. Data
/// object is the base class for different types of objects in a section, whether will be shown with a template view,
/// an unique view, or will contain more data objects by grouping.
public class WWDataObject : NSObject {
    
    override init() {
        super.init()
    }
    
    internal var deleteOption : WWOptionViewItem!
    internal var internalParent : WWSubGroupDataObject?
    internal var options : [WWOptionViewItem] = []
    
    /// If a data object belongs to a group, its parent will be contained here.
    public var parent: WWSubGroupDataObject? {
        get {
            return internalParent
        }
    }
    
    /// This functions helps to create a delete option related to an item. There can only be one delete option per item, and its not going to execute the function `optionSelected` of the `WWCollapsibleFormDelegate`.
    /// - Parameters:
    ///     - title: The title of the option.
    ///     - backgroundColor: The color of the background of the option. Default: red.
    ///     - image: The image related to this option. Default: nil.
    ///     - padding: The padding between the text and the container view. Default: 10.
    /// - Returns: The option that should be append using the `appendOptions` function.
    public func createDeleteOption(title: String = "Delete", backgroundColor: UIColor? = UIColor.red, image : UIImage? = nil, padding : CGFloat = 10) -> WWOptionViewItem {
        if deleteOption == nil {
            deleteOption = WWOptionViewItem(title: title, backgroundColor: backgroundColor, image: image, padding: padding)
        }
        
        return deleteOption
    }
    
    /// Append a new option to the option list. Based on its configuration, it will appear at the left or the right side of the option.
    /// - Parameter option: The option to be appended.
    public func appendOptions(option : WWOptionViewItem) {
        if option == deleteOption {
            let searchedDeleteOption : WWOptionViewItem? = self.options.filter({ $0 == option }).first
            if searchedDeleteOption != nil {
                return
            }
        }
        self.options.append(option)
    }
    
    /// Retrieve a hash value that represents this object.
    public override var hash: Int {
        get {
            return ObjectIdentifier(self).hashValue
        }
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        if let otherObject = object as? WWDataObject {
            return self.hash == otherObject.hash
        }
        return false
    }
    
    /// Returns a Boolean value that indicates whether the receiver and a given object are equal.
    /// This method defines what it means for instances to be equal. For example, a container object might define two containers as equal if their corresponding objects all respond true to an isEqual(_:) request. See the NSData, NSDictionary, NSArray, and NSString class specifications for examples of the use of this method.
    /// - Remark: If two objects are equal, they must have the same hash value. This last point is particularly important if you define isEqual(_:) in a subclass and intend to put instances of that subclass into a collection. Make sure you also define hash in your subclass.
    /// - Parameter data: The object to be compared to the receiver.
    /// - Returns: true if the receiver and anObject are equal, otherwise false.
    public func isEqual(to data: WWDataObject) -> Bool {
        return self.isEqual(data)
    }
}
