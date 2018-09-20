//
//  WWStatusDecorator.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
public class WWStatusDecorator : NSObject {
    internal var decoratorFunction : ((_:UIView) -> Void)?
    
    public init(decoratorFunction: @escaping ((_:UIView) -> Void)) {
        super.init()
        self.decoratorFunction = decoratorFunction
    }
    
    public func decorate(view : UIView) {
        self.decoratorFunction?(view)
    }
}


protocol WWStatusApplier : NSObjectProtocol {
    var enableDecorator: WWStatusDecorator? { get set }
    var disableDecorator: WWStatusDecorator? { get set }
}

extension WWStatusApplier where Self : UIView {
    func applyStatus(status: WWSection.WWStatus) {
        if status == .disabled {
            self.disableDecorator?.decorate(view: self)
        } else if (status == .enabled) {
            self.enableDecorator?.decorate(view: self)
        }
    }
}
