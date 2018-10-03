//
//  WWSwipeViewAnimation.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 10/3/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
enum WWSwipeViewEasingFunction : Int {
    case linear
    case quadIn
    case quadOut
    case quadInOut
    case cubicIn
    case cubicOut
    case cubicInOut
    case bounceIn
    case bounceOut
    case bounceInOut
}

class WWSwipeViewAnimation : NSObject {
    var duration : CFTimeInterval = CATransaction.animationDuration()
    var easingFunction : WWSwipeViewEasingFunction = .bounceOut
    func value(elapsed: CGFloat, duration: CFTimeInterval, from: CGFloat, to: CGFloat) {
        
    }
}
