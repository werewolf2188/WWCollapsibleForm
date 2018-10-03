//
//  WWSwipeViewDelegate.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 10/3/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
/*
 @protocol MGSwipeTableCellDelegate <NSObject>
 
 @optional
 /**
 * Delegate method to enable/disable swipe gestures
 * @return YES if swipe is allowed
 **/
 -(BOOL) swipeTableCell:(nonnull MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction fromPoint:(CGPoint) point;
 -(BOOL) swipeTableCell:(nonnull MGSwipeTableCell*) cell canSwipe:(MGSwipeDirection) direction DEPRECATED_ATTRIBUTE; //backwards compatibility
 
 /**
 * Delegate method invoked when the current swipe state changes
 @param state the current Swipe State
 @param gestureIsActive YES if the user swipe gesture is active. No if the uses has already ended the gesture
 **/
 -(void) swipeTableCell:(nonnull MGSwipeTableCell*) cell didChangeSwipeState:(MGSwipeState) state gestureIsActive:(BOOL) gestureIsActive;
 
 /**
 * Called when the user clicks a swipe button or when a expandable button is automatically triggered
 * @return YES to autohide the current swipe buttons
 **/
 -(BOOL) swipeTableCell:(nonnull MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion;
 /**
 * Delegate method to setup the swipe buttons and swipe/expansion settings
 * Buttons can be any kind of UIView but it's recommended to use the convenience MGSwipeButton class
 * Setting up buttons with this delegate instead of using cell properties improves memory usage because buttons are only created in demand
 * @param cell the UITableViewCell to configure. You can get the indexPath using [tableView indexPathForCell:cell]
 * @param direction The swipe direction (left to right or right to left)
 * @param swipeSettings instance to configure the swipe transition and setting (optional)
 * @param expansionSettings instance to configure button expansions (optional)
 * @return Buttons array
 **/
 -(nullable NSArray<UIView*>*) swipeTableCell:(nonnull MGSwipeTableCell*) cell swipeButtonsForDirection:(MGSwipeDirection)direction
 swipeSettings:(nonnull MGSwipeSettings*) swipeSettings expansionSettings:(nonnull MGSwipeExpansionSettings*) expansionSettings;
 
 /**
 * Called when the user taps on a swiped cell
 * @return YES to autohide the current swipe buttons
 **/
 -(BOOL) swipeTableCell:(nonnull MGSwipeTableCell *)cell shouldHideSwipeOnTap:(CGPoint) point;
 
 /**
 * Called when the cell will begin swiping
 * Useful to make cell changes that only are shown after the cell is swiped open
 **/
 -(void) swipeTableCellWillBeginSwiping:(nonnull MGSwipeTableCell *) cell;
 
 /**
 * Called when the cell will end swiping
 **/
 -(void) swipeTableCellWillEndSwiping:(nonnull MGSwipeTableCell *) cell;
 
 @end

 */
