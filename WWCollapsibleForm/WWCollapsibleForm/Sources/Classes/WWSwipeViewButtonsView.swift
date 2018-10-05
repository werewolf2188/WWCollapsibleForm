//
//  WWSwipeViewButtonsView.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 10/4/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
//#pragma mark Button Container View and transitions
//
//@interface MGSwipeButtonsView : UIView
//@property (nonatomic, weak) MGSwipeTableCell * cell;
//@property (nonatomic, strong) UIColor * backgroundColorCopy;
//@end
//
//@implementation MGSwipeButtonsView
//{
//    NSArray * _buttons;
//    UIView * _container;
//    BOOL _fromLeft;
//    UIView * _expandedButton;
//    UIView * _expandedButtonAnimated;
//    UIView * _expansionBackground;
//    UIView * _expansionBackgroundAnimated;
//    CGRect _expandedButtonBoundsCopy;
//    MGSwipeDirection _direction;
//    MGSwipeF _expansionLayout;
//    CGFloat _expansionOffset;
//    CGFloat _buttonsDistance;
//    CGFloat _safeInset;
//    BOOL _autoHideExpansion;
//}
//
//#pragma mark Layout
//
//-(instancetype) initWithButtons:(NSArray*) buttonsArray direction:(MGSwipeDirection) direction swipeSettings:(MGSwipeSettings*) settings safeInset: (CGFloat) safeInset
//{
//    CGFloat containerWidth = 0;
//    CGSize maxSize = CGSizeZero;
//    UIView* lastButton = [buttonsArray lastObject];
//    for (UIView * button in buttonsArray) {
//        containerWidth += button.bounds.size.width + (lastButton == button ? 0 : settings.buttonsDistance);
//        maxSize.width = MAX(maxSize.width, button.bounds.size.width);
//        maxSize.height = MAX(maxSize.height, button.bounds.size.height);
//    }
//    if (!settings.allowsButtonsWithDifferentWidth) {
//        containerWidth = maxSize.width * buttonsArray.count + settings.buttonsDistance * (buttonsArray.count - 1);
//    }
//
//    if (self = [super initWithFrame:CGRectMake(0, 0, containerWidth + safeInset, maxSize.height)]) {
//        _fromLeft = direction == MGSwipeDirectionLeftToRight;
//        _buttonsDistance = settings.buttonsDistance;
//        _container = [[UIView alloc] initWithFrame:self.bounds];
//        _container.clipsToBounds = YES;
//        _container.backgroundColor = [UIColor clearColor];
//        _direction = direction;
//        _safeInset = safeInset;
//        [self addSubview:_container];
//        _buttons = _fromLeft ? buttonsArray: [[buttonsArray reverseObjectEnumerator] allObjects];
//        for (UIView * button in _buttons) {
//            if ([button isKindOfClass:[UIButton class]]) {
//                UIButton * btn = (UIButton*)button;
//                [btn removeTarget:nil action:@selector(mgButtonClicked:) forControlEvents:UIControlEventTouchUpInside]; //Remove all targets to avoid problems with reused buttons among many cells
//                [btn addTarget:self action:@selector(mgButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//            }
//            if (!settings.allowsButtonsWithDifferentWidth) {
//                button.frame = CGRectMake(0, 0, maxSize.width, maxSize.height);
//            }
//            button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//            [_container insertSubview:button atIndex: _fromLeft ? 0: _container.subviews.count];
//        }
//        // Expand last button to make it look good with a notch.
//        if (safeInset > 0 && settings.expandLastButtonBySafeAreaInsets && _buttons.count > 0) {
//            UIView * notchButton = _direction == MGSwipeDirectionRightToLeft ? [_buttons lastObject] : [_buttons firstObject];
//            notchButton.frame = CGRectMake(0, 0, notchButton.frame.size.width + safeInset, notchButton.frame.size.height);
//            [self adjustContentEdge:notchButton edgeDelta:safeInset];
//        }
//        [self resetButtons];
//    }
//    return self;
//}
//
//-(void) dealloc
//    {
//        for (UIView * button in _buttons) {
//            if ([button isKindOfClass:[UIButton class]]) {
//                [(UIButton *)button removeTarget:self action:@selector(mgButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//            }
//        }
//}
//
//-(void) resetButtons
//    {
//        CGFloat offsetX = 0;
//        UIView* lastButton = [_buttons lastObject];
//        for (UIView * button in _buttons) {
//            button.frame = CGRectMake(offsetX, 0, button.bounds.size.width, self.bounds.size.height);
//            button.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//            offsetX += button.bounds.size.width + (lastButton == button ? 0 : _buttonsDistance);
//        }
//}
//
//-(void) setSafeInset:(CGFloat)safeInset extendEdgeButton:(BOOL) extendEdgeButton isRTL: (BOOL) isRTL {
//    CGFloat diff = safeInset - _safeInset;
//    if (diff != 0) {
//        _safeInset = safeInset;
//        // Adjust last button length (fit the safeInset to make it look good with a notch)
//        if (extendEdgeButton) {
//            UIView * edgeButton = _direction == MGSwipeDirectionRightToLeft ? [_buttons lastObject] : [_buttons firstObject];
//            edgeButton.frame = CGRectMake(0, 0, edgeButton.bounds.size.width + diff, edgeButton.frame.size.height);
//            // Adjust last button content edge (to correctly align the text/icon)
//            [self adjustContentEdge:edgeButton edgeDelta:diff];
//        }
//
//        CGRect frame = self.frame;
//        CGAffineTransform transform = self.transform;
//        self.transform = CGAffineTransformIdentity;
//        // Adjust container width
//        frame.size.width += diff;
//        // Adjust position to match width and safeInsets chages
//        if (_direction == MGSwipeDirectionLeftToRight) {
//            frame.origin.x = -frame.size.width + safeInset * (isRTL ? 1 : -1);
//        }
//        else {
//            frame.origin.x = self.superview.bounds.size.width + safeInset * (isRTL ? 1 : -1);
//        }
//
//        self.frame = frame;
//        self.transform = transform;
//        [self resetButtons];
//    }
//}
//
//-(void) adjustContentEdge: (UIView *) view edgeDelta:(CGFloat) delta {
//    if ([view isKindOfClass:[UIButton class]]) {
//        UIButton * btn = (UIButton *) view;
//        UIEdgeInsets contentInsets = btn.contentEdgeInsets;
//        if (_direction == MGSwipeDirectionRightToLeft) {
//            contentInsets.right += delta;
//        }
//        else {
//            contentInsets.left += delta;
//        }
//        btn.contentEdgeInsets = contentInsets;
//    }
//}
//
//-(void) layoutExpansion: (CGFloat) offset
//{
//    _expansionOffset = offset;
//    _container.frame = CGRectMake(_fromLeft ? 0: self.bounds.size.width - offset, 0, offset, self.bounds.size.height);
//    if (_expansionBackgroundAnimated && _expandedButtonAnimated) {
//        _expansionBackgroundAnimated.frame = [self expansionBackgroundRect:_expandedButtonAnimated];
//    }
//}
//
//-(void) layoutSubviews
//    {
//        [super layoutSubviews];
//        if (_expandedButton) {
//            [self layoutExpansion:_expansionOffset];
//        }
//        else {
//            _container.frame = self.bounds;
//        }
//}
//
//-(CGRect) expansionBackgroundRect: (UIView *) button
//{
//    CGFloat extra = 100.0f; //extra size to avoid expansion background size issue on iOS 7.0
//    if (_fromLeft) {
//        return CGRectMake(-extra, 0, button.frame.origin.x + extra, _container.bounds.size.height);
//    }
//    else {
//        return CGRectMake(button.frame.origin.x +  button.bounds.size.width, 0,
//                          _container.bounds.size.width - (button.frame.origin.x + button.bounds.size.width ) + extra
//            ,_container.bounds.size.height);
//    }
//
//}
//
//-(void) expandToOffset:(CGFloat) offset settings:(MGSwipeExpansionSettings*) settings
//{
//    if (settings.buttonIndex < 0 || settings.buttonIndex >= _buttons.count) {
//        return;
//    }
//    if (!_expandedButton) {
//        _expandedButton = [_buttons objectAtIndex: _fromLeft ? settings.buttonIndex : _buttons.count - settings.buttonIndex - 1];
//        CGRect previusRect = _container.frame;
//        [self layoutExpansion:offset];
//        [self resetButtons];
//        if (!_fromLeft) { //Fix expansion animation for right buttons
//            for (UIView * button in _buttons) {
//                CGRect frame = button.frame;
//                frame.origin.x += _container.bounds.size.width - previusRect.size.width;
//                button.frame = frame;
//            }
//        }
//        _expansionBackground = [[UIView alloc] initWithFrame:[self expansionBackgroundRect:_expandedButton]];
//        _expansionBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        if (settings.expansionColor) {
//            _backgroundColorCopy = _expandedButton.backgroundColor;
//            _expandedButton.backgroundColor = settings.expansionColor;
//        }
//        _expansionBackground.backgroundColor = _expandedButton.backgroundColor;
//        if (UIColor.clearColor == _expandedButton.backgroundColor) {
//            // Provides access to more complex content for display on the background
//            _expansionBackground.layer.contents = _expandedButton.layer.contents;
//        }
//        [_container addSubview:_expansionBackground];
//        _expansionLayout = settings.expansionLayout;
//
//        CGFloat duration = _fromLeft ? _cell.leftExpansion.animationDuration : _cell.rightExpansion.animationDuration;
//        [UIView animateWithDuration: duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//            self->_expandedButton.hidden = NO;
//
//            if (self->_expansionLayout == MGSwipeExpansionLayoutCenter) {
//            self->_expandedButtonBoundsCopy = self->_expandedButton.bounds;
//            self->_expandedButton.layer.mask = nil;
//            self->_expandedButton.layer.transform = CATransform3DIdentity;
//            self->_expandedButton.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//            [self->_expandedButton.superview bringSubviewToFront:self->_expandedButton];
//            self->_expandedButton.frame = self->_container.bounds;
//            self->_expansionBackground.frame = [self expansionBackgroundRect:self->_expandedButton];
//            }
//            else if (self->_expansionLayout == MGSwipeExpansionLayoutNone) {
//            [self->_expandedButton.superview bringSubviewToFront:self->_expandedButton];
//            self->_expansionBackground.frame = self->_container.bounds;
//            }
//            else if (self->_fromLeft) {
//            self->_expandedButton.frame = CGRectMake(self->_container.bounds.size.width - self->_expandedButton.bounds.size.width, 0, self->_expandedButton.bounds.size.width, self->_expandedButton.bounds.size.height);
//            self->_expandedButton.autoresizingMask|= UIViewAutoresizingFlexibleLeftMargin;
//            self->_expansionBackground.frame = [self expansionBackgroundRect:self->_expandedButton];
//            }
//            else {
//            self->_expandedButton.frame = CGRectMake(0, 0, self->_expandedButton.bounds.size.width, self->_expandedButton.bounds.size.height);
//            self->_expandedButton.autoresizingMask|= UIViewAutoresizingFlexibleRightMargin;
//            self->_expansionBackground.frame = [self expansionBackgroundRect:self->_expandedButton];
//            }
//
//            } completion:^(BOOL finished) {
//            }];
//        return;
//    }
//    [self layoutExpansion:offset];
//}
//
//-(void) endExpansionAnimated:(BOOL) animated
//{
//    if (_expandedButton) {
//        _expandedButtonAnimated = _expandedButton;
//        if (_expansionBackgroundAnimated && _expansionBackgroundAnimated != _expansionBackground) {
//            [_expansionBackgroundAnimated removeFromSuperview];
//        }
//        _expansionBackgroundAnimated = _expansionBackground;
//        _expansionBackground = nil;
//        _expandedButton = nil;
//        if (_backgroundColorCopy) {
//            _expansionBackgroundAnimated.backgroundColor = _backgroundColorCopy;
//            _expandedButtonAnimated.backgroundColor = _backgroundColorCopy;
//            _backgroundColorCopy = nil;
//        }
//        CGFloat duration = _fromLeft ? _cell.leftExpansion.animationDuration : _cell.rightExpansion.animationDuration;
//        [UIView animateWithDuration: animated ? duration : 0.0 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
//            self->_container.frame = self.bounds;
//            if (self->_expansionLayout == MGSwipeExpansionLayoutCenter) {
//            self->_expandedButtonAnimated.frame = self->_expandedButtonBoundsCopy;
//            }
//            [self resetButtons];
//            self->_expansionBackgroundAnimated.frame = [self expansionBackgroundRect:self->_expandedButtonAnimated];
//            } completion:^(BOOL finished) {
//            [self->_expansionBackgroundAnimated removeFromSuperview];
//            }];
//    }
//    else if (_expansionBackground) {
//        [_expansionBackground removeFromSuperview];
//        _expansionBackground = nil;
//    }
//}
//
//-(UIView*) getExpandedButton
//    {
//        return _expandedButton;
//}
//
//#pragma mark Trigger Actions
//
//-(BOOL) handleClick: (id) sender fromExpansion:(BOOL) fromExpansion
//{
//    bool autoHide = false;
//    #pragma clang diagnostic push
//    #pragma clang diagnostic ignored "-Wundeclared-selector"
//    if ([sender respondsToSelector:@selector(callMGSwipeConvenienceCallback:)]) {
//        //call convenience block callback if exits (usage of MGSwipeButton class is not compulsory)
//        autoHide = [sender performSelector:@selector(callMGSwipeConvenienceCallback:) withObject:_cell];
//    }
//    #pragma clang diagnostic pop
//
//    if (_cell.delegate && [_cell.delegate respondsToSelector:@selector(swipeTableCell:tappedButtonAtIndex:direction:fromExpansion:)]) {
//        NSInteger index = [_buttons indexOfObject:sender];
//        if (!_fromLeft) {
//            index = _buttons.count - index - 1; //right buttons are reversed
//        }
//        autoHide|= [_cell.delegate swipeTableCell:_cell tappedButtonAtIndex:index direction:_fromLeft ? MGSwipeDirectionLeftToRight : MGSwipeDirectionRightToLeft fromExpansion:fromExpansion];
//    }
//
//    if (fromExpansion && autoHide) {
//        _expandedButton = nil;
//        _cell.swipeOffset = 0;
//    }
//    else if (autoHide) {
//        [_cell hideSwipeAnimated:YES];
//    }
//
//    return autoHide;
//
//}
////button listener
//-(void) mgButtonClicked: (id) sender
//{
//    [self handleClick:sender fromExpansion:NO];
//}
//
//
//#pragma mark Transitions
//
//-(void) transitionStatic:(CGFloat) t
//{
//    const CGFloat dx = self.bounds.size.width * (1.0 - t);
//    CGFloat offsetX = 0;
//
//    UIView* lastButton = [_buttons lastObject];
//    for (UIView *button in _buttons) {
//        CGRect frame = button.frame;
//        frame.origin.x = offsetX + (_fromLeft ? dx : -dx);
//        button.frame = frame;
//        offsetX += frame.size.width + (button == lastButton ? 0 : _buttonsDistance);
//    }
//}
//
//-(void) transitionDrag:(CGFloat) t
//{
//    //No Op, nothing to do ;)
//}
//
//-(void) transitionClip:(CGFloat) t
//{
//    CGFloat selfWidth = self.bounds.size.width;
//    CGFloat offsetX = 0;
//
//    UIView* lastButton = [_buttons lastObject];
//    for (UIView *button in _buttons) {
//        CGRect frame = button.frame;
//        CGFloat dx = roundf(frame.size.width * 0.5 * (1.0 - t)) ;
//        frame.origin.x = _fromLeft ? (selfWidth - frame.size.width - offsetX) * (1.0 - t) + offsetX + dx : offsetX * t - dx;
//        button.frame = frame;
//
//        if (_buttons.count > 1) {
//            CAShapeLayer *maskLayer = [CAShapeLayer new];
//            CGRect maskRect = CGRectMake(dx - 0.5, 0, frame.size.width - 2 * dx + 1.5, frame.size.height);
//            CGPathRef path = CGPathCreateWithRect(maskRect, NULL);
//            maskLayer.path = path;
//            CGPathRelease(path);
//            button.layer.mask = maskLayer;
//        }
//
//        offsetX += frame.size.width + (button == lastButton ? 0 : _buttonsDistance);
//    }
//}
//
//-(void) transtitionFloatBorder:(CGFloat) t
//{
//    CGFloat selfWidth = self.bounds.size.width;
//    CGFloat offsetX = 0;
//
//    UIView* lastButton = [_buttons lastObject];
//    for (UIView *button in _buttons) {
//        CGRect frame = button.frame;
//        frame.origin.x = _fromLeft ? (selfWidth - frame.size.width - offsetX) * (1.0 - t) + offsetX : offsetX * t;
//        button.frame = frame;
//        offsetX += frame.size.width + (button == lastButton ? 0 : _buttonsDistance);
//    }
//}
//
//-(void) transition3D:(CGFloat) t
//{
//    const CGFloat invert = _fromLeft ? 1.0 : -1.0;
//    const CGFloat angle = M_PI_2 * (1.0 - t) * invert;
//    CATransform3D transform = CATransform3DIdentity;
//    transform.m34 = -1.0/400.0f; //perspective 1/z
//    const CGFloat dx = -_container.bounds.size.width * 0.5 * invert;
//    const CGFloat offset = dx * 2 * (1.0 - t);
//    transform = CATransform3DTranslate(transform, dx - offset, 0, 0);
//    transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0);
//    transform = CATransform3DTranslate(transform, -dx, 0, 0);
//    _container.layer.transform = transform;
//}
//
//-(void) transition:(MGSwipeTransition) mode percent:(CGFloat) t
//{
//    switch (mode) {
//    case MGSwipeTransitionStatic: [self transitionStatic:t]; break;
//    case MGSwipeTransitionDrag: [self transitionDrag:t]; break;
//    case MGSwipeTransitionClipCenter: [self transitionClip:t]; break;
//    case MGSwipeTransitionBorder: [self transtitionFloatBorder:t]; break;
//    case MGSwipeTransitionRotate3D: [self transition3D:t]; break;
//    }
//    if (_expandedButtonAnimated && _expansionBackgroundAnimated) {
//        _expansionBackgroundAnimated.frame = [self expansionBackgroundRect:_expandedButtonAnimated];
//    }
//}
//
//@end
