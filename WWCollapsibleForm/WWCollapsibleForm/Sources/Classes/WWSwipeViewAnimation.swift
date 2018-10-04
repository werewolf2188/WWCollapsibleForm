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
    
    static var mgEaseLinear : (_: CGFloat, _: CGFloat, _: CGFloat) -> CGFloat = { (t, b, c) in
        return c * t + b
    }
    
    static var mgEaseInQuad : (_: CGFloat, _: CGFloat, _: CGFloat) -> CGFloat = { (t, b, c) in
        return c * t * t + b
    }
    
    static var mgEaseOutQuad : (_: CGFloat, _: CGFloat, _: CGFloat) -> CGFloat = { (t, b, c) in
        return -c * t * (t - 2) + b
    }
    
    static var mgEaseInOutQuad : (_: CGFloat, _: CGFloat, _: CGFloat) -> CGFloat = { (t, b, c) in
        var tt = t * 2
        if ((tt) < 1) {
            return c / 2 * t * t + b
        }
        tt = t
        tt = tt - 1;
        return -c/2 * (t * ( t - 2 ) - 1) + b
    }
    
    static var mgEaseInCubic : (_: CGFloat, _: CGFloat, _: CGFloat) -> CGFloat = { (t, b, c) in
        return c * t * t * t + b
    }
    
    static var mgEaseOutCubic : (_: CGFloat, _: CGFloat, _: CGFloat) -> CGFloat = { (t, b, c) in
        var tt = t - 1
        return c * (tt * tt * tt + 1) + b
    }
    
    static var mgEaseInOutCubic : (_: CGFloat, _: CGFloat, _: CGFloat) -> CGFloat = { (t, b, c) in
        var tt = t * 2
        if ((tt) < 1) {
            return c / 2 * t * t + b
        }
        tt = t
        tt = tt - 2;
        return c/2 * (t * t * t + 2) + b
    }
    
    static var mgEaseOutBounce : (_: CGFloat, _: CGFloat, _: CGFloat) -> CGFloat = { (t, b, c) in
        if (t < (1/2.75)) {
            return c * (7.5625 * t * t) + b
        } else if (t < (2/2.75)) {
            let tt = t - (1.5/2.75)
            return c * (7.5625 * tt * tt + 0.75) + b
        } else if (t < (2.5/2.75)) {
            let tt = t - (2.25/2.75)
            return c * (7.5625 * tt * tt + 0.9375) + b
        } else {
            let tt = t - (2.625/2.75)
            return c * (7.5625 * tt * tt + 0.984375) + b
        }
    }
    
    static var mgEaseInBounce : (_: CGFloat, _: CGFloat, _: CGFloat) -> CGFloat = { (t, b, c) in
        return c - WWSwipeViewAnimation.mgEaseOutBounce (1.0 - t, 0, c) + b
    }
    
    static var mgEaseInOutBounce : (_: CGFloat, _: CGFloat, _: CGFloat) -> CGFloat = { (t, b, c) in
        if (t < 0.5)  {
            return mgEaseInBounce (t * 2, 0, c) * 0.5 + b
        }
        return mgEaseOutBounce (1.0 - t * 2, 0, c) * 0.5 + c * 0.5 + b
    }
    
    var duration : CGFloat = 0.3
    var easingFunction : WWSwipeViewEasingFunction = .cubicOut
    func value(elapsed: CGFloat, duration: CFTimeInterval, from: CGFloat, to: CGFloat) -> CGFloat {
        let t = min(CFTimeInterval(elapsed) / duration, 1.0)
        if (t == 1.0) {
            return to //precise last value
        }
        var easingFunc : (_: CGFloat, _: CGFloat, _: CGFloat) -> CGFloat = WWSwipeViewAnimation.mgEaseLinear
        
        switch easingFunction {
        case .linear:
            easingFunc = WWSwipeViewAnimation.mgEaseLinear
        case .quadIn:
            easingFunc = WWSwipeViewAnimation.mgEaseInQuad
        case .quadOut:
            easingFunc = WWSwipeViewAnimation.mgEaseOutQuad
        case .quadInOut:
            easingFunc = WWSwipeViewAnimation.mgEaseInOutQuad
        case .cubicIn:
            easingFunc = WWSwipeViewAnimation.mgEaseInCubic
        case .cubicOut:
            easingFunc = WWSwipeViewAnimation.mgEaseOutCubic
        case .cubicInOut:
            easingFunc = WWSwipeViewAnimation.mgEaseInOutCubic
        case .bounceIn:
            easingFunc = WWSwipeViewAnimation.mgEaseInBounce
        case .bounceOut:
            easingFunc = WWSwipeViewAnimation.mgEaseOutBounce
        case .bounceInOut:
            easingFunc = WWSwipeViewAnimation.mgEaseInOutBounce
        }
        
        return easingFunc(CGFloat(t), from, to - from)
    }
}
