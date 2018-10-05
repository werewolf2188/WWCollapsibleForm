//
//  WWSwipeViewExpansionSettings.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 10/3/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

enum WWSwipeViewExpansionLayout : Int {
    case border
    case center
    case none
}

class WWSwipeViewExpansionSettings : NSObject {
    var buttonIndex: Int = -1
    var fillOnTrigger : Bool = false
    var threshold: CGFloat = 1.3
    var expansionColor : UIColor!
    var expansionLayout: WWSwipeViewExpansionLayout = .border
    var triggerAnimation: WWSwipeViewAnimation! = WWSwipeViewAnimation()
    var animationDuration: CGFloat = 0.2
}
