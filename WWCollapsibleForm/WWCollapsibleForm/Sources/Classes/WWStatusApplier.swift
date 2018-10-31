//
//  WWStatusApplier.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 9/20/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
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
