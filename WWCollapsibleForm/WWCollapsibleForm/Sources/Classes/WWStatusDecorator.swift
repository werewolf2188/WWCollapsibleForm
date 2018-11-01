//
//  WWStatusDecorator.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

/// A status decorator is a class that will be used to decorate the style of the view and its propeties, whenever a section changes its status.
public class WWStatusDecorator : NSObject {
    internal var decoratorFunction : ((_:UIView) -> Void)?
    
    /// Initializes the decorator with a function to be used whenever the decorator is being executed (that is, when the
    /// section changes state).
    public init(decoratorFunction: @escaping ((_:UIView) -> Void)) {
        super.init()
        self.decoratorFunction = decoratorFunction
    }
    
    func decorate(view : UIView) {
        self.decoratorFunction?(view)
    }
}
