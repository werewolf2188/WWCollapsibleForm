//
//  WWSwipeViewSettings.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 10/3/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

enum WWSwipeViewTransition : Int {
    case border
    case `static`
    case drage
    case clipCenter
    case rotate3D
}

class WWSwipeViewSettings : NSObject {
    var transition : WWSwipeViewTransition = .border
    var threshold : CGFloat = 0
    var offset : CGFloat = 0
    var topMargin : CGFloat = 0
    var bottomMargin : CGFloat = 0
    var buttonsDistance : CGFloat = 0
    var expandLastButtonBySafeAreaInsets : Bool = false
    
    var showAnimation : WWSwipeViewAnimation!
    var hideAnimation : WWSwipeViewAnimation!
    var stretchAnimation : WWSwipeViewAnimation!
    
    var animationDuration : CGFloat = 0
    var keepButtonsSwiped : Bool = false
    var onlySwipeButtons : Bool = false
    var enableSwipeBounces : Bool = false
    
    var swipeBounceRate : CGFloat = 1.0
    var allowsButtonsWithDifferentWidth : Bool = false
}
