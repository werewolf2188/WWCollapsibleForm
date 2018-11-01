//
//  WWCollapsibleFormConfiguration.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 10/31/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

/// This class helps the form to have a centralize way of getting the basic configuration that can be modify during loading time.
public class WWCollapsibleFormConfiguration : NSObject {
    /// The minimum height a footer inside a section can have.
    public var minimumFooterHeight : CGFloat = 20
    /// If the form footer should appeared animated after all section have chosen an item.
    public var animateFooter : Bool = true
    /// The background color of the container view inside the form.
    public var containerBackgroundColor : UIColor = UIColor.white
    /// The color of every separator inside the items.
    public var separatorColor: UIColor = UIColor.black
    /// The leading spacing of the separator inside the items.
    public var separatorLeading : CGFloat = 30
    /// The trailing spacing of the separator inside the itmes. In case to be nan, the leading spacing will be taken.
    public var separatorTrailing : CGFloat = CGFloat.nan
}
