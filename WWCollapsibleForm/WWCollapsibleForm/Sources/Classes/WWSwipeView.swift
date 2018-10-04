//
//  WWSwipeView.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 10/2/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
//ENUMS

enum WWSwipeViewState : Int {
    case none
    case swipingLeftToRight
    case swipingRightToLeft
    case expandingLeftToRight
    case expandingRightToLeft
}

enum WWSwipeViewDirection : Int {
    case leftToRight
    case rightToLeft
}

//HELPER CLASSES
fileprivate class WWSwipeAnimationData : NSObject {
    var from : CGFloat = 0
    var to : CGFloat = 0
    var duration : CFTimeInterval = 0
    var start : CFTimeInterval = 0
    var animation : WWSwipeViewAnimation!
}

class WWSwipeView : UIView {
    //MARK: Internal properties
    //Leave delegate for later
    var options : [WWOptionViewItem]!
    var swipeContentView : UIView!
    var leftButtons: [UIView]!
    var rightButtons: [UIView]!
    
    var leftSwipeSettings : WWSwipeViewSettings!
    var rightSwipeSettings : WWSwipeViewSettings!
    
    var leftExpansion : WWSwipeViewExpansionSettings!
    var rightExpansion : WWSwipeViewExpansionSettings!
    
    var isSwipeGestureActive : Bool = false
    var allowsMultipleSwipe : Bool = false
    var allowsButtonsWithDifferentWidth : Bool = false
    
    var allowsSwipeWhenTappingButtons: Bool = true
    var allowsOppositeSwipe : Bool = true
    var preservesSelectionStatus : Bool = false
    var touchOnDismissSwipe : Bool = false
    
    var swipeBackgroundColor : UIColor!
    var swipeOffset : CGFloat = 0
    
    var state: WWSwipeViewState! = .none
    //MARK: Private properties
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    convenience init(options : [WWOptionViewItem], frame: CGRect = CGRect.zero) {
        self.init(frame: frame)
        self.options = options
        self.leftButtons = self.options.filter({ $0.side == .left }).map({ $0.getView() })
        self.rightButtons = self.options.filter({ $0.side == .right }).map({ $0.getView() })
    }
    
    //MARK: Internal functions
    func hideSwipe(animated: Bool, completion: ((Bool) ->Void)? = nil) {
        
    }
    
    func showSwipe(direction: WWSwipeViewDirection, animated: Bool, completion: ((Bool) ->Void)? = nil) {
        
    }
    
    func setSwipeOffset(offset:CGFloat, animated: Bool, animation: WWSwipeViewAnimation? = nil, completion: ((Bool) ->Void)? = nil) {
        
    }
    
    func expandSwipe(direction: WWSwipeViewDirection, animated: Bool) {
        
    }
    
    func refreshContentView() {
        
    }
    
    func refreshButtons() {
        
    }
    
    //MARK: Private functions
    private func initialize() {
        self.options = []
        self.leftButtons = []
        self.rightButtons = []
    }
}
