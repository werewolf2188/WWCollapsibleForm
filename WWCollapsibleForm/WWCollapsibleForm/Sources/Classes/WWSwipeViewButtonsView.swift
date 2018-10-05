//
//  WWSwipeViewButtonsView.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 10/4/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

class WWSwipeViewButtonView : UIView {
    weak var currentView : WWSwipeView!
    var backgroundColorCopy : UIColor!
    
    private var buttons : [UIView]!
    private var container : UIView!
    private var fromLeft : Bool!
    private var expandedButton : UIView!
    private var expansionBackground : UIView!
    private var expandedButtonAnimated : UIView!
    private var expansionBackgroundAnimated : UIView!
    private var expandedButtonBoundsCopy : CGRect!
    private var direction : WWSwipeViewDirection = .leftToRight
    private var expansionLayout : WWSwipeViewExpansionLayout = .border
    private var expansionOffset : CGFloat = 0
    private var buttonsDistance : CGFloat = 0
    private var safeInset : CGFloat = 0
    private var autoHideExpansion : Bool = false
    
    init(buttons: [UIView], direction: WWSwipeViewDirection, settings: WWSwipeViewSettings, safeInset: CGFloat) {
        var containerWidth : CGFloat = 0
        var maxSize : CGSize = CGSize.zero
        let lastButton : UIView? = buttons.last
        for button in buttons {
            containerWidth += button.bounds.size.width + (lastButton == button ? 0 : settings.buttonsDistance)
            maxSize.width = max(maxSize.width, button.bounds.size.width)
            maxSize.height = max(maxSize.height, button.bounds.size.height)
        }
        
        if (!settings.allowsButtonsWithDifferentWidth) {
            containerWidth = maxSize.width * CGFloat(buttons.count) + settings.buttonsDistance * (CGFloat(buttons.count) - 1);
        }
        
        super.init(frame: CGRect(x: 0, y: 0, width:  containerWidth + safeInset, height: maxSize.height))
        fromLeft = direction == .leftToRight
        buttonsDistance = settings.buttonsDistance
        container = UIView(frame: self.bounds)
        container.clipsToBounds = true
        container.backgroundColor = UIColor.clear
        self.direction = direction
        self.safeInset = safeInset
        self.addSubview(container)
        self.buttons = fromLeft ? buttons : buttons.reversed()
        for button in self.buttons {
            if button is UIButton {
                (button as? UIButton)?.removeTarget(nil, action: #selector(self.mgButtonClicked(sender:)), for: .touchUpInside)
                (button as? UIButton)?.addTarget(self, action: #selector(self.mgButtonClicked(sender:)), for: .touchUpInside)
            }
            
            if (!settings.allowsButtonsWithDifferentWidth) {
                button.frame = CGRect(x: 0, y: 0, width: maxSize.width, height: maxSize.height)
                button.autoresizingMask = [.flexibleHeight]
                container.insertSubview(button, at: fromLeft ? 0: container.subviews.count)
            }
            
        }
        if (safeInset > 0 && settings.expandLastButtonBySafeAreaInsets && self.buttons.count > 0) {
            if let notchButton : UIView = direction == .rightToLeft ? self.buttons.last : self.buttons.first {
                notchButton.frame = CGRect(x: 0, y: 0, width: notchButton.frame.size.width + safeInset, height: notchButton.frame.size.height)
                self.adjustContentEdge(view: notchButton, edgeDelta: safeInset)
            }
        }
        self.resetButtons()
    }
    
    deinit {
        for button in self.buttons {
            if button is UIButton {
                (button as? UIButton)?.removeTarget(nil, action: #selector(self.mgButtonClicked(sender:)), for: .touchUpInside)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (self.expandedButton != nil) {
            self.layoutExpansion(offset: self.expansionOffset)
        } else {
            self.container.frame = self.bounds
        }
    }
}

//MARK: Layout
extension WWSwipeViewButtonView {
    func adjustContentEdge(view: UIView, edgeDelta delta: CGFloat) {
        
        if let button = view as? UIButton {
            var contentInsets : UIEdgeInsets = button.contentEdgeInsets
            if direction == .rightToLeft {
                contentInsets.right += delta
            } else {
                contentInsets.left += delta
            }
            button.contentEdgeInsets = contentInsets
        }
    }
    
    func resetButtons() {
        var offsetX : CGFloat = 0
        let lastButton = self.buttons.last
        for button in self.buttons {
            button.frame = CGRect(x: offsetX, y: 0, width: button.bounds.size.width, height: self.bounds.size.height)
            button.autoresizingMask = [.flexibleHeight]
            offsetX += button.bounds.size.width + (lastButton == button ? 0 : buttonsDistance)
        }
    }
    
    func setSafeInset(_ safeInset: CGFloat, extendEdgeButton: Bool, isRTL: Bool) {
        let diff : CGFloat = safeInset - self.safeInset
        if (diff != 0) {
            self.safeInset = safeInset
            if (extendEdgeButton) {
                if let edgeButton : UIView = direction == .rightToLeft ? self.buttons.last : self.buttons.first {
                    edgeButton.frame = CGRect(x: 0, y: 0, width: edgeButton.frame.size.width + diff, height: edgeButton.frame.size.height)
                    self.adjustContentEdge(view: edgeButton, edgeDelta: diff)
                }
            }
            
            var frame : CGRect = self.frame
            let transform : CGAffineTransform = self.transform
            self.transform = .identity
            frame.size.width += diff
            if (self.direction == .leftToRight) {
                frame.origin.x = -frame.size.width + safeInset * (isRTL ? 1 : -1)
            } else {
                frame.origin.x = (self.superview?.bounds.size.width ?? 0) + safeInset * (isRTL ? 1 : -1)
            }
            self.frame = frame
            self.transform = transform
            self.resetButtons()
        }
    }
    
    func layoutExpansion(offset: CGFloat) {
        self.expansionOffset = offset
        self.container.frame = CGRect(x: self.fromLeft ? 0 : self.bounds.size.width - offset, y: 0, width: offset, height: self.bounds.size.height)
        if self.expansionBackgroundAnimated != nil && self.expandedButtonAnimated != nil {
            self.expansionBackgroundAnimated.frame = self.expansionBackgroundRect(button: self.expandedButtonAnimated)
        }
    }
    
    func expansionBackgroundRect(button: UIView) -> CGRect {
        let extra : CGFloat = 100
        if (self.fromLeft) {
            return CGRect(x: -extra, y: 0, width: button.frame.origin.x + extra, height: self.container.bounds.size.height)
        } else {
            return CGRect(x: button.frame.origin.x +  button.bounds.size.width, y: 0, width: self.container.bounds.size.width - (button.frame.origin.x + button.bounds.size.width ), height: container.bounds.size.height)
        }
    }
    
    func expandToOffset(_ offset: CGFloat, settings: WWSwipeViewExpansionSettings) {
        if (settings.buttonIndex < 0 || settings.buttonIndex >= self.buttons.count) {
            return;
        }
        
        if (self.expandedButton == nil) {
            self.expandedButton = self.buttons[self.fromLeft ? settings.buttonIndex : self.buttons.count - settings.buttonIndex - 1]
            var previousRect : CGRect = container.frame
            self.layoutExpansion(offset: offset)
            self.resetButtons()
            if (!self.fromLeft) {
                for button in self.buttons {
                    var frame : CGRect = button.frame
                    frame.origin.x += container.bounds.size.width - previousRect.size.width
                    button.frame = frame
                }
            }
            self.expansionBackground = UIView(frame: self.expansionBackgroundRect(button: expandedButton))
            self.expansionBackground.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            if settings.expansionColor != nil {
                self.backgroundColorCopy = self.expandedButton.backgroundColor
                self.expandedButton.backgroundColor = settings.expansionColor
            }
            self.expansionBackground.backgroundColor = self.expandedButton.backgroundColor
            if UIColor.clear == self.expandedButton.backgroundColor {
                self.expansionBackground.layer.contents = self.expandedButton.layer.contents;
            }
            self.container.addSubview(self.expansionBackground)
            self.expansionLayout = settings.expansionLayout
            let duration = self.fromLeft ? self.currentView.leftExpansion.animationDuration : self.currentView.rightExpansion.animationDuration
            UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: [.beginFromCurrentState], animations: {
                self.animationExpandToOffset()
                
            }, completion: nil)
           return
        }
        self.layoutExpansion(offset: offset)
    }
}

//MARK: Clicks
extension WWSwipeViewButtonView {
    @objc func mgButtonClicked(sender: Any) {
        
    }
}

//MARK: Animations
extension WWSwipeViewButtonView {
    func animationExpandToOffset() {
        self.expandedButton.isHidden = false
        if (self.expansionLayout == .center) {
            self.expandedButtonBoundsCopy = self.expandedButton.bounds
            self.expandedButton.layer.mask = nil
            self.expandedButton.layer.transform = CATransform3DIdentity
            self.expandedButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.expandedButton.superview?.bringSubview(toFront: self.expandedButton)
            self.expandedButton.frame = self.container.bounds
            self.expansionBackground.frame = self.expansionBackgroundRect(button: self.expandedButton)
        } else if (self.expansionLayout == .none) {
            self.expandedButton.superview?.bringSubview(toFront: self.expandedButton)
            self.expansionBackground.frame = self.container.bounds
        } else if self.fromLeft {
            
        }
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
    }
}
//#pragma mark Button Container View and transitions
//
//
//@implementation MGSwipeButtonsView

//
//#pragma mark Layout
//
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
