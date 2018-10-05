//
//  WWSwipeViewDelegate.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 10/3/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

protocol WWSwipeViewDelegate : NSObjectProtocol {
    func canSwipe(_ swipeView: WWSwipeView, direction: WWSwipeViewDirection, from point: CGPoint) -> Bool
    func canSwipe(_ swipeView: WWSwipeView, direction: WWSwipeViewDirection) -> Bool
    
    func didChangeSwipeState(_ swipeView: WWSwipeView, state: WWSwipeViewState, isGestureActive: Bool)
    func tappedButtonAtIndex(_ swipeView: WWSwipeView, index: Int, direction: WWSwipeViewDirection, fromExpansion: Bool) -> Bool
    
    func canSwipe(_ swipeView: WWSwipeView, direction: WWSwipeViewDirection, setting: WWSwipeViewSettings, expansionSettings: WWSwipeViewExpansionSettings) -> [UIView]?
    
    func shouldHideSwipeOnTap(_ swipeView: WWSwipeView, point: CGPoint) -> Bool
    
    func swipeTableCellWillBeginSwiping(_ swipeView: WWSwipeView)
    func swipeTableCellWillEndSwiping(_ swipeView: WWSwipeView)
}
