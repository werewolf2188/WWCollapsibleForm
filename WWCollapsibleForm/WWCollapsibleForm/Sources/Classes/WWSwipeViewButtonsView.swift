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
            let previousRect : CGRect = container.frame
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
            self.expandedButton.frame = CGRect(x: self.container.bounds.size.width - self.expandedButton.bounds.size.width, y: 0, width: self.expandedButton.bounds.size.width, height: self.expandedButton.bounds.size.height)
            self.expandedButton.autoresizingMask = [self.expandedButton.autoresizingMask, .flexibleLeftMargin]
            self.expansionBackground.frame = self.expansionBackgroundRect(button: self.expandedButton)
        } else {
            self.expandedButton.frame = CGRect(x: 0, y: 0, width: self.expandedButton.bounds.size.width, height: self.expandedButton.bounds.size.height)
            self.expandedButton.autoresizingMask = [self.expandedButton.autoresizingMask, .flexibleRightMargin]
            self.expansionBackground.frame = self.expansionBackgroundRect(button: self.expandedButton)
        }
    }
    
    func endExpansionAnimated(animated: Bool) {
        if (self.expandedButton != nil) {
            self.expandedButtonAnimated = self.expandedButton
            if self.expansionBackgroundAnimated != nil && self.expansionBackgroundAnimated != self.expansionBackground {
                self.expansionBackgroundAnimated.removeFromSuperview()
            }
            
            self.expansionBackgroundAnimated = self.expansionBackground
            self.expansionBackground = nil
            self.expandedButton = nil
            if self.backgroundColorCopy != nil {
                self.expansionBackgroundAnimated.backgroundColor = self.backgroundColorCopy
                self.expandedButtonAnimated.backgroundColor = self.backgroundColorCopy
                self.backgroundColorCopy = nil
            }
            let duration = self.fromLeft ? self.currentView.leftExpansion.animationDuration : self.currentView.rightExpansion.animationDuration
            UIView.animate(withDuration: TimeInterval(duration), delay: 0, options: [.beginFromCurrentState], animations: {
                self.container.frame = self.bounds
                if self.expansionLayout == .center {
                    self.expandedButtonAnimated.frame = self.expandedButtonBoundsCopy
                }
                self.resetButtons()
                self.expansionBackgroundAnimated.frame = self.expansionBackgroundRect(button: self.expandedButtonAnimated)
            }, completion: { (finished) in
                self.expansionBackgroundAnimated.removeFromSuperview()
            })
        }
        else if self.expansionBackground != nil {
            self.expansionBackground.removeFromSuperview()
            self.expansionBackground  = nil
        }
    }
    
    func getExpandedButton() -> UIView? {
        return self.expandedButton
    }
}

//MARK: Clicks
extension WWSwipeViewButtonView {
    @discardableResult
    func handleClick(sender: Any, fromExpansion: Bool) -> Bool {
        var autoHide : Bool = false
        let senderObject = sender as AnyObject
        if senderObject.responds(to: Selector(("callMGSwipeConvenienceCallback:"))){
            autoHide = autoHide || (senderObject.perform(Selector(("callMGSwipeConvenienceCallback:")), with: self.currentView)?.takeRetainedValue() as? Bool ?? false)
        }
        if let delegate = self.currentView.delegate, let button = sender as? UIView, var index :Int = self.buttons.firstIndex(of: button) {
            
            if !self.fromLeft {
                index = self.buttons.count - index - 1
            }
            
            autoHide = autoHide || delegate.tappedButtonAtIndex(self.currentView, index: index, direction: self.fromLeft ? .leftToRight : .rightToLeft, fromExpansion: fromExpansion)
        }
        if (fromExpansion && autoHide) {
            self.expandedButton = nil;
            self.currentView.swipeOffset = 0;
        } else if (autoHide) {
            self.currentView.hideSwipe(animated: true)
        }
        return autoHide
    }
    
    @objc func mgButtonClicked(sender: Any) {
        self.handleClick(sender: sender, fromExpansion: false)
    }
}

//MARK: Transitions
extension WWSwipeViewButtonView {
    func transitionStatic(t: CGFloat) {
        let dx : CGFloat = self.bounds.size.width * (1.0 - t)
        var offsetX : CGFloat = 0
        if let lastButton = self.buttons.last {
            for button in self.buttons {
                var frame = button.frame
                frame.origin.x = offsetX + (self.fromLeft ? dx : -dx)
                button.frame = frame
                offsetX += frame.size.width + (button == lastButton ? 0 : self.buttonsDistance)
            }
        }
    }
    
    func transitionDrag(t: CGFloat) {
        //No Op, nothing to do ;)
    }
    
    func transitionClip(t: CGFloat) {
        let selfWidth : CGFloat = self.bounds.size.width
        var offsetX : CGFloat = 0
        
        if let lastButton = self.buttons.last {
            for button in self.buttons {
                var frame = button.frame
                let dx : CGFloat = round(frame.size.width * 0.5 * (1.0 - t))
                frame.origin.x = self.fromLeft ? (selfWidth - frame.size.width - offsetX) * (1.0 - t) + offsetX + dx : offsetX * t - dx
                button.frame = frame
                
                if (self.buttons.count > 1){
                    let maskLayer : CAShapeLayer = CAShapeLayer()
                    let maskRect : CGRect = CGRect(x: dx - 0.5, y: 0, width: frame.size.width - 2 * dx + 1.5, height: frame.size.height)
                    let path : CGPath = CGPath(rect: maskRect, transform: nil)
                    maskLayer.path = path
                    button.layer.mask = maskLayer
                }
                offsetX += frame.size.width + (button == lastButton ? 0 : self.buttonsDistance)
            }
        }
    }
    
    func transtitionFloatBorder(t: CGFloat) {
        let selfWidth : CGFloat = self.bounds.size.width
        var offsetX : CGFloat = 0
        if let lastButton = self.buttons.last {
            for button in self.buttons {
                var frame = button.frame
                frame.origin.x = self.fromLeft ? (selfWidth - frame.size.width - offsetX) * (1.0 - t) + offsetX : offsetX * t
                button.frame = frame
                offsetX += frame.size.width + (button == lastButton ? 0 : self.buttonsDistance)
            }
        }
    }
    
    func transition3D(t: CGFloat) {
        let invert : CGFloat = self.fromLeft ? 1.0 : -1.0
        let angle : CGFloat = (CGFloat.pi / 2) * (1.0 - t) * invert
        var transform : CATransform3D = CATransform3DIdentity
        transform.m34 = -1.0/400.0; //perspective 1/z
        let dx : CGFloat = self.container.bounds.size.width * 0.5 * invert
        let offset : CGFloat = dx * 2 * (1.0 - t)
        transform = CATransform3DTranslate(transform, dx - offset, 0, 0)
        transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0)
        transform = CATransform3DTranslate(transform, -dx, 0, 0)
        self.container.layer.transform = transform
    }
    
    func transition(_ mode :WWSwipeViewTransition, percent t: CGFloat) {
        switch mode {
        case .static:
            self.transitionStatic(t: t)
        case .drag:
            self.transitionDrag(t: t)
        case .clipCenter:
            self.transitionClip(t: t)
        case .border:
            self.transtitionFloatBorder(t: t)
        case .rotate3D:
            self.transition3D(t: t)
        }
        
        if self.expandedButtonAnimated != nil && self.expansionBackgroundAnimated != nil {
            self.expansionBackgroundAnimated.frame = self.expansionBackgroundRect(button: self.expandedButtonAnimated)
        }
    }
}
