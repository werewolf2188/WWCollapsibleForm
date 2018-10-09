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
fileprivate class WWSwipeViewAnimationData : NSObject {
    var from : CGFloat = 0
    var to : CGFloat = 0
    var duration : CFTimeInterval = 0
    var start : CFTimeInterval = 0
    var animation : WWSwipeViewAnimation!
}

class WWSwipeView : UIView {
    //MARK: Internal properties
    weak var delegate : WWSwipeViewDelegate?
    var options : [WWOptionViewItem]!
    var swipeContentView : UIView! {
        get {
            if (self._swipeContentView == nil) {
                self._swipeContentView = UIView(frame: self.bounds)
                self._swipeContentView.backgroundColor = UIColor.clear
                self._swipeContentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self._swipeContentView.layer.zPosition = 9
                self.addSubview(self._swipeContentView)
            }
            return _swipeContentView
        }
    }
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
    var swipeState: WWSwipeViewState!
    
    //MARK: Private properties
    
    var state: WWSwipeViewState! = .none
    //MARK: Private properties
    fileprivate var tapRecognizer :UITapGestureRecognizer!
    fileprivate var panRecognizer :UIPanGestureRecognizer!
    fileprivate var panStartPoint : CGPoint!
    fileprivate var panStartOffset: CGFloat!
    fileprivate var targetOffset: CGFloat!
    
    fileprivate var swipeOverlay: UIView!
    fileprivate var swipeView: UIImageView!
    fileprivate var _swipeContentView: UIView!
    fileprivate var leftView: WWSwipeViewButtonView!
    fileprivate var rightView: WWSwipeViewButtonView!
    fileprivate var allowSwipeRightToLeft: Bool!
    fileprivate var allowSwipeLeftToRight: Bool!
    fileprivate weak var activeExpansion : WWSwipeViewButtonView!
    
    fileprivate var tableInputOverlay: WWSwipeViewInputOverlay!
    fileprivate var overlayEnabled: Bool!
    //fileprivate var previusSelectionStyle: UITableViewCellSelectionStyle!
    fileprivate var previousHiddenViews: Set<UIView>!
    fileprivate var triggerStateChanges: Bool!
    
    fileprivate var animationData: WWSwipeViewAnimationData!
    fileprivate var animationCompletion: ((_ :Bool)-> Void)!
    fileprivate var displayLink: CADisplayLink!
    fileprivate var firstSwipeState: WWSwipeViewState!

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
    
    deinit {
        self.hideSwipeOverlayIfNeeded()
    }
    
    //MARK: Override functions
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (self.swipeContentView != nil) {
            swipeContentView.frame = self.bounds
        }
        
        if (self.swipeOverlay != nil) {
            let prevSize : CGSize = self.swipeView.bounds.size
            self.swipeOverlay.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height)
            self.fixRegionAndAccesoryViews()
            if self.swipeView.image != nil && !prevSize.equalTo(self.swipeOverlay.bounds.size) {
                let safeInsets : UIEdgeInsets = self.getSafeInsets()
                if self.leftView != nil {
                    let width : CGFloat = self.leftView.bounds.size.width
                    self.leftView.setSafeInset(safeInsets.left, extendEdgeButton: self.leftSwipeSettings.expandLastButtonBySafeAreaInsets, isRTL: self.isRTL())
                    
                    if self.swipeOffset > 0 && self.leftView.bounds.size.width != width {
                        self.swipeOffset += self.leftView.bounds.size.width - width
                    }
                }
                
                if self.rightView != nil {
                    let width : CGFloat = self.rightView.bounds.size.width
                    self.rightView.setSafeInset(safeInsets.right, extendEdgeButton: self.rightSwipeSettings.expandLastButtonBySafeAreaInsets, isRTL: self.isRTL())
                    
                    if self.swipeOffset < 0 && self.rightView.bounds.size.width != width {
                        self.swipeOffset -= self.rightView.bounds.size.width - width
                    }
                }
                
                //refresh contentView in situations like layout change, orientation chage, table resize, etc.
                self.refreshContentView()
            }
            
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if (newSuperview == nil) { //remove the table overlay when a cell is removed from the table
            self.hideSwipeOverlayIfNeeded()
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if !self.isHidden && self.swipeOverlay != nil && !self.swipeOverlay.isHidden {
            let targets : [UIView?] = [self.leftView, self.rightView]
            for i in 0..<2 {
                guard let target : UIView = targets[i] else {
                    continue
                }
                let p : CGPoint = self.convert(point, to: target)
                if target.bounds.contains(p){
                    return target.hitTest(p, with: event)
                }
            }
        }
        return super.hitTest(point, with: event)
    }
    
    func refreshContentView() {
        let currentOffset : CGFloat = self.swipeOffset
        let prevValue : Bool = self.triggerStateChanges
        self.triggerStateChanges = false
        self.swipeOffset = 0
        self.swipeOffset = currentOffset
        self.triggerStateChanges = prevValue
    }
    
    func refreshButtons(usingDelegate: Bool) {
        if (usingDelegate) {
            self.leftButtons = []
            self.rightButtons = []
        }
        
        if (self.leftView != nil) {
            self.leftView.removeFromSuperview()
            self.leftView = nil
        }
        if (self.rightView != nil) {
            self.rightView.removeFromSuperview()
            self.rightView = nil
        }
        
        self.createSwipeViewIfNeeded()
        self.refreshContentView()
    }
    
    //MARK: Private functions
    fileprivate func initialize(cleanButtons: Bool = true) {
        
        if (cleanButtons) {
            self.options = []
            self.leftButtons = []
            self.rightButtons = []
            self.leftSwipeSettings = WWSwipeViewSettings()
            self.rightSwipeSettings = WWSwipeViewSettings()
            self.leftExpansion = WWSwipeViewExpansionSettings()
            self.rightExpansion = WWSwipeViewExpansionSettings()
        }
        self.animationData = WWSwipeViewAnimationData()
        self.panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.panHandler(gesture:)))
        self.addGestureRecognizer(self.panRecognizer)
        self.panRecognizer.delegate = self
        self.activeExpansion = nil
        self.previousHiddenViews = Set<UIView>()
        self.swipeState = .none
        self.triggerStateChanges = true
        self.allowsSwipeWhenTappingButtons = true
        self.preservesSelectionStatus = false
        self.allowsOppositeSwipe = true
        self.firstSwipeState = .none
    }
    
    fileprivate func hideSwipeOverlayIfNeeded() {
        if (!self.overlayEnabled) {
            return
        }
        self.overlayEnabled = false
        self.swipeOverlay.isHidden = true
        self.swipeView.image = nil
        if self._swipeContentView != nil {
            self._swipeContentView.removeFromSuperview()
            self.addSubview(self._swipeContentView)
        }
        if self.tableInputOverlay != nil {
            self.tableInputOverlay.removeFromSuperview()
            self.tableInputOverlay = nil
        }
        
        self.setAccesoryViewsHidden(false)
        if let delegate = self.delegate {
            delegate.swipeTableCellWillEndSwiping(self)
        }
        if self.tapRecognizer != nil {
            self.removeGestureRecognizer(self.tapRecognizer)
            self.tapRecognizer = nil
        }
    }
    
    fileprivate func cleanViews() {
        self.hideSwipe(animated: false)
        if self.displayLink != nil {
            self.displayLink.invalidate()
            self.displayLink = nil
        }
        if self.swipeOverlay != nil {
            self.swipeOverlay.removeFromSuperview()
            self.swipeOverlay = nil
        }
        self.leftView = nil
        self.rightView = nil
        
        if self.panRecognizer != nil {
            self.panRecognizer.delegate = nil
            self.removeGestureRecognizer(self.panRecognizer)
            self.panRecognizer = nil
        }
    }
    
    fileprivate func fixRegionAndAccesoryViews() {
        //Fix right to left layout direction for arabic and hebrew languagues
        if self.bounds.size.width != self.bounds.size.width && self.isRTL() {
            self.swipeOverlay.frame = CGRect(x: -self.bounds.size.width + self.bounds.size.width, y: 0, width: swipeOverlay.bounds.size.width, height: swipeOverlay.bounds.size.height)
        }
    }
    
    fileprivate func getSafeInsets() -> UIEdgeInsets {
        #if swift(>=3.0)
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets
        } else {
            return UIEdgeInsets.zero
        }
        #else
        return UIEdgeInsets.zero
        #endif
    }
    
    fileprivate func fetchButtonsIfNeeded() {
        if (self.leftButtons.count == 0), let delegate = self.delegate {
            self.leftButtons = delegate.canSwipe(self, direction: .leftToRight, setting: self.leftSwipeSettings, expansionSettings: self.leftExpansion) ?? []
        }
        
        if (self.rightButtons.count == 0), let delegate = self.delegate {
            self.rightButtons = delegate.canSwipe(self, direction: .rightToLeft, setting: self.rightSwipeSettings, expansionSettings: self.rightExpansion) ?? []
        }
    }
    
    fileprivate func createSwipeViewIfNeeded() {
        let safeInsets : UIEdgeInsets = self.getSafeInsets()
        
        if self.swipeOverlay == nil {
            self.swipeOverlay = UIView(frame: self.bounds)
            self.fixRegionAndAccesoryViews()
            self.swipeOverlay.isHidden = true
            self.swipeOverlay.backgroundColor = self.backgroundColorForSwipe()
            self.swipeView = UIImageView(frame: self.swipeOverlay.bounds)
            self.swipeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.swipeView.contentMode = .center
            self.swipeView.clipsToBounds = true
            self.swipeOverlay.addSubview(self.swipeView)
            self.addSubview(self.swipeOverlay)
        }
        self.fetchButtonsIfNeeded()
        
        if (self.leftView == nil && self.leftButtons.count > 0) {
            self.leftSwipeSettings.allowsButtonsWithDifferentWidth = leftSwipeSettings.allowsButtonsWithDifferentWidth || self.allowsButtonsWithDifferentWidth
            self.leftView = WWSwipeViewButtonView(buttons: self.leftButtons, direction: .leftToRight, settings: self.leftSwipeSettings, safeInset: safeInsets.left)
            self.leftView.currentView = self
            self.leftView.frame = CGRect(x: -self.leftView.bounds.size.width + safeInsets.left * (self.isRTL() ? 1 : -1),
                                         y: leftSwipeSettings.topMargin,
                                         width: leftView.bounds.size.width,
                                         height: self.swipeOverlay.bounds.size.height - self.leftSwipeSettings.topMargin - self.leftSwipeSettings.bottomMargin)
            self.leftView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            self.swipeOverlay.addSubview(self.leftView)
        }
        
        if (self.rightView == nil && self.rightButtons.count > 0) {
            self.rightSwipeSettings.allowsButtonsWithDifferentWidth = rightSwipeSettings.allowsButtonsWithDifferentWidth || self.allowsButtonsWithDifferentWidth
            self.rightView = WWSwipeViewButtonView(buttons: self.rightButtons, direction: .rightToLeft, settings: self.rightSwipeSettings, safeInset: safeInsets.right)
            self.rightView.currentView = self
            self.rightView.frame = CGRect(x: self.swipeOverlay.bounds.size.width + safeInsets.right * (self.isRTL() ? 1 : -1),
                                         y: rightSwipeSettings.topMargin,
                                         width: rightView.bounds.size.width,
                                         height: self.swipeOverlay.bounds.size.height - self.rightSwipeSettings.topMargin - self.rightSwipeSettings.bottomMargin)
            self.rightView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
            self.swipeOverlay.addSubview(self.rightView)
        }
        
        if (self.leftView != nil) {
            self.leftView.setSafeInset(safeInsets.left, extendEdgeButton: self.leftSwipeSettings.expandLastButtonBySafeAreaInsets, isRTL: self.isRTL())
        }
        if (self.rightView != nil) {
            self.rightView.setSafeInset(safeInsets.right, extendEdgeButton: self.rightSwipeSettings.expandLastButtonBySafeAreaInsets, isRTL: self.isRTL())
        }
    }
    
    fileprivate func showSwipeOverlayIfNeeded() {
        if (self.overlayEnabled) {
            return
        }
        self.overlayEnabled = true
        ///REMOVE
        if !self.preservesSelectionStatus {
            //self.selected = false // if it was a cell
        }
        if (self._swipeContentView != nil) {
            self._swipeContentView.removeFromSuperview()
            self.delegate?.swipeTableCellWillBeginSwiping(self)
        }
        let cropSize : CGSize = self.bounds.size
        self.swipeView.image = self.imageFromView(view: self, cropSize: cropSize)
        self.swipeOverlay.isHidden = false
        
        if (self._swipeContentView != nil) {
            self.swipeView.addSubview(self._swipeContentView)
        }
        
        if self.allowsMultipleSwipe {
            //REMOVE OR REPLAN
            //Since this unlikely to happen, I'll code it differently
            if (self.tableInputOverlay != nil) {
                self.tableInputOverlay.removeFromSuperview()
                self.tableInputOverlay = nil
            }
            self.tableInputOverlay = WWSwipeViewInputOverlay(frame: UIApplication.shared.keyWindow?.bounds ?? CGRect.zero)
            self.tableInputOverlay.currentView = self
            UIApplication.shared.keyWindow?.addSubview(self.tableInputOverlay)
        }
//        self.selectionStyle = _previusSelectionStyle;
//        NSArray * selectedRows = self.parentTable.indexPathsForSelectedRows;
//        if ([selectedRows containsObject:[self.parentTable indexPathForCell:self]]) {
//            self.selected = NO; //Hack: in some iOS versions setting the selected property to YES own isn't enough to force the cell to redraw the chosen selectionStyle
//            self.selected = YES;
//        }
        self.setAccesoryViewsHidden(true)
        self.tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler(gesture:)))
        self.tapRecognizer.cancelsTouchesInView = true
        self.tapRecognizer.delegate = self
        self.addGestureRecognizer(self.tapRecognizer)
    }
    
    fileprivate func backgroundColorForSwipe() -> UIColor {
        if self.swipeBackgroundColor != nil {
            return self.swipeBackgroundColor
        } else if let color = self.backgroundColor, color.isEqual(UIColor.clear) {
            return color
        }
        return UIColor.clear
    }
    
    fileprivate func imageFromView(view: UIView, cropSize: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(cropSize, false, 0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
        let image: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    fileprivate func setAccesoryViewsHidden(_ hidden: Bool) {
        //    if (self.accessoryView) {
        //        self.accessoryView.hidden = hidden;
        //    }
        //    for (UIView * view in self.contentView.superview.subviews) {
        //        if (view != self.contentView && ([view isKindOfClass:[UIButton class]] || [NSStringFromClass(view.class) rangeOfString:@"Disclosure"].location != NSNotFound)) {
        //            view.hidden = hidden;
        //        }
        //    }
        //
        for view in self.subviews {
            if view == self.swipeOverlay || view == self._swipeContentView {
                continue
            }
            if (hidden && !view.isHidden) {
                self.previousHiddenViews.insert(view)
            } else if !hidden && self.previousHiddenViews.contains(view) {
                view.isHidden = false
            }
        }
       
        if (!hidden) {
            self.previousHiddenViews.removeAll()
        }
    }
        
}

//MARK: Table View Cell function. Might not need them
extension WWSwipeView {
    func prepareForReuse() {
        self.cleanViews()
        if self.swipeState != .none {
            self.triggerStateChanges = true
            self.update(state: .none)
        }
        let cleanButtons : Bool = self.delegate != nil
        self.initialize(cleanButtons: cleanButtons)
    }
    
    func update(state: WWSwipeViewState) {
        if !self.triggerStateChanges || self.swipeState == state {
            return
        }
        self.swipeState = state
        self.delegate?.didChangeSwipeState(self, state: state, isGestureActive: self.isSwipeGestureActive)
    }
    
    func setEditing(_ editing: Bool, animated: Bool = false) {
        if editing {
            self.swipeOffset = 0
        }
    }
    
    func parentTable() -> UITableView? {
        var view : UIView? = self.superview
        while view != nil {
            if view is UITableView {
                return view as? UITableView
            }
            view = view?.superview
        }
        return nil
    }
}

//MARK: Animations
extension WWSwipeView  {
    func setSwipeOffset(newOffset:CGFloat, animation: WWSwipeViewAnimation?, completion: ((Bool) ->Void)? = nil) {
        if self.displayLink != nil {
            self.displayLink.invalidate()
            self.displayLink = nil
        }
        
        if self.animationCompletion != nil {
            let callbackCopy = self.animationCompletion
            self.animationCompletion = nil
            callbackCopy?(true)
        }
        
        if newOffset != 0 {
            self.createSwipeViewIfNeeded()
        }
        
        if animation != nil {
            self.swipeOffset = newOffset
            completion?(true)
            return
        }
        self.animationCompletion = completion;
        self.triggerStateChanges = false;
        self.animationData.from = self.swipeOffset;
        self.animationData.to = newOffset;
        self.animationData.duration = CFTimeInterval(animation?.duration ?? 0);
        self.animationData.start = 0;
        self.animationData.animation = animation;
        
        
        self.displayLink = CADisplayLink(target: self, selector: #selector(self.animationTick(timer:)))
        self.displayLink.add(to: RunLoop.main, forMode: .commonModes)
    }
    
    func setSwipeOffset(newOffset:CGFloat, animated: Bool, completion: ((Bool) ->Void)? = nil) {
        let animation : WWSwipeViewAnimation? = animated ? WWSwipeViewAnimation() : nil
        self.setSwipeOffset(newOffset: newOffset, animation: animation, completion: completion)
    }
    
    func setSwipeOffset(newOffset:CGFloat, animated: Bool, animation: WWSwipeViewAnimation?, completion: ((Bool) ->Void)? = nil) {
        let sign : CGFloat = newOffset > 0 ? 1 : -1
        let activeButtons : WWSwipeViewButtonView! = sign < 0 ? self.rightView : self.leftView
        let activeSettings : WWSwipeViewSettings = sign < 0 ? self.rightSwipeSettings : self.leftSwipeSettings
        
        if activeSettings.enableSwipeBounces {
            self.swipeOffset = newOffset
            let maxUnbouncedOffset : CGFloat = sign * activeButtons.bounds.size.width
            
            if ((sign > 0 && newOffset > maxUnbouncedOffset) || (sign < 0 && newOffset < maxUnbouncedOffset)) {
                self.swipeOffset = maxUnbouncedOffset + (newOffset - maxUnbouncedOffset) * activeSettings.swipeBounceRate
            }
        } else {
            let maxOffset : CGFloat = sign * activeButtons.bounds.size.width
            self.swipeOffset = sign > 0 ? min(newOffset, maxOffset) : max(newOffset, maxOffset)
        }
        let offset : CGFloat = fabs(self.swipeOffset)
        if (activeButtons == nil || offset == 0) {
            if self.leftView != nil {
                self.leftView.endExpansionAnimated(animated: false)
            }
            if self.rightView != nil {
                self.rightView.endExpansionAnimated(animated: false)
            }
            self.targetOffset = 0
            self.update(state: .none)
            return
        } else {
            self.showSwipeOverlayIfNeeded()
            let swipeThreshold : CGFloat = activeSettings.threshold
            let keepButtons : Bool = activeSettings.keepButtonsSwiped
            self.targetOffset = keepButtons && offset > activeButtons.bounds.size.width * swipeThreshold ? activeButtons.bounds.size.width * sign : 0
        }
        let onlyButtons : Bool = activeSettings.onlySwipeButtons
        let safeInsets : UIEdgeInsets = self.getSafeInsets()
        let safeInset : CGFloat = self.isRTL() ? safeInsets.right :  -safeInsets.left
        self.swipeView.transform = self.swipeView.transform.translatedBy(x: safeInset + (onlyButtons ? 0 : self.swipeOffset), y: 0)
        
        //animate existing buttons
        let but: [WWSwipeViewButtonView?] = [self.leftView , self.rightView]
        let settings: [WWSwipeViewSettings] = [self.leftSwipeSettings , self.rightSwipeSettings]
        let expansions: [WWSwipeViewExpansionSettings] = [self.leftExpansion , self.rightExpansion]
        
        for i in 0..<2 {
            guard let view : WWSwipeViewButtonView = but[i] else {
                continue
            }
            let translation : CGFloat = min(offset, view.bounds.size.width) * sign + settings[i].offset * sign
            view.transform = view.transform.translatedBy(x: translation, y: 0)
            
            if view != activeButtons {
                continue
            }
            let expand = expansions[i].buttonIndex >= 0 && offset > view.bounds.size.width * expansions[i].threshold
            if expand {
                view.expandToOffset(offset, settings: expansions[i])
                self.targetOffset = expansions[i].fillOnTrigger ? self.bounds.size.width * sign : 0
                self.activeExpansion = view
                
                self.update(state: Bool(exactly: NSNumber(integerLiteral: i)) ?? false ? .expandingRightToLeft : .expandingLeftToRight)
            } else {
                view.endExpansionAnimated(animated: true)
                self.activeExpansion = nil
                let t : CGFloat = min(1, offset/view.bounds.size.width)
                view.transition(settings[i].transition, percent: t)
                self.update(state: Bool(exactly: NSNumber(integerLiteral: i)) ?? false ? .swipingRightToLeft : .swipingLeftToRight)
            }
        }
    }
    
    func hideSwipe(animated: Bool, completion: ((Bool) ->Void)? = nil) {
        let animation : WWSwipeViewAnimation? = animated ? (self.swipeOffset > 0 ? self.leftSwipeSettings.hideAnimation : self.rightSwipeSettings.hideAnimation) : nil
        self.setSwipeOffset(newOffset: 0, animated: animated, animation: animation, completion: completion)
    }
    
    func showSwipe(direction: WWSwipeViewDirection, animated: Bool, completion: ((Bool) ->Void)? = nil) {
        self.createSwipeViewIfNeeded()
        self.allowSwipeLeftToRight = self.leftButtons.count > 0
        self.allowSwipeRightToLeft = self.rightButtons.count > 0
        let buttonsView : UIView! = direction == .leftToRight ? self.leftView : self.rightView
        
        if buttonsView != nil {
            let s : CGFloat = direction == .leftToRight ? 1 : -1
             let animation : WWSwipeViewAnimation? = animated ? (direction == .leftToRight ? self.leftSwipeSettings.showAnimation : self.rightSwipeSettings.showAnimation) : nil
            self.setSwipeOffset(newOffset: buttonsView.bounds.size.width * s, animation: animation, completion: nil)
        }
    }
    
    func expandSwipe(direction: WWSwipeViewDirection, animated: Bool) {
        let s : CGFloat = direction == .leftToRight ? 1 : -1
        let expSetting : WWSwipeViewExpansionSettings = direction == .leftToRight ? self.leftExpansion : self.rightExpansion
        
        if (self.activeExpansion != nil && expSetting.fillOnTrigger) {
            self.createSwipeViewIfNeeded()
            self.allowSwipeLeftToRight = self.leftButtons.count > 0
            self.allowSwipeRightToLeft = self.rightButtons.count > 0
            let buttonsView : UIView! = direction == .leftToRight ? self.leftView : self.rightView
            
            if buttonsView != nil {
                let expansionView : WWSwipeViewButtonView? = buttonsView as? WWSwipeViewButtonView
                self.setSwipeOffset(newOffset: buttonsView.bounds.size.width * s * expSetting.threshold * 2, animation: expSetting.triggerAnimation) { (_) in
                    expansionView?.endExpansionAnimated(animated: true)
                    self.setSwipeOffset(newOffset: 0, animated: false, completion: nil)
                }
            }
        }
    }
    
    @objc func animationTick(timer: CADisplayLink) {
        if self.animationData.start != 0 {
            self.animationData.start = timer.timestamp
        }
        let elapsed : CFTimeInterval = timer.timestamp - self.animationData.start
        let  completed : Bool = elapsed >= self.animationData.duration
        
        if (completed) {
            self.triggerStateChanges = true
        }
        self.swipeOffset = self.animationData.animation.value(elapsed: CGFloat(elapsed), duration: self.animationData.duration, from: self.animationData.from, to: self.animationData.to)
        
        if (completed) {
            timer.invalidate()
            self.invalidateDisplayLink()
        }
    }
    
    func invalidateDisplayLink() {
        self.displayLink.invalidate()
        self.displayLink = nil
        if self.animationCompletion != nil {
            let callbackCopy = self.animationCompletion
            self.animationCompletion = nil
            callbackCopy?(true)
        }
    }
}


//MARK: Gestures
extension WWSwipeView : UIGestureRecognizerDelegate {
    //(void) panHandler: (UIPanGestureRecognizer *)gesture
    @objc func panHandler(gesture: UIPanGestureRecognizer) {
    }
    
    @objc func tapHandler(gesture: UITapGestureRecognizer) {
    }
}

//#pragma mark MGSwipeTableCell Implementation
//
//
//@implementation MGSwipeTableCell
//
//#pragma mark Gestures
//
//-(void) cancelPanGesture
//{
//    if (_panRecognizer.state != UIGestureRecognizerStateEnded && _panRecognizer.state != UIGestureRecognizerStatePossible) {
//        _panRecognizer.enabled = NO;
//        _panRecognizer.enabled = YES;
//        if (self.swipeOffset) {
//            [self hideSwipeAnimated:YES];
//        }
//    }
//}
//
//-(void) tapHandler: (UITapGestureRecognizer *) recognizer
//{
//    BOOL hide = YES;
//    if (_delegate && [_delegate respondsToSelector:@selector(swipeTableCell:shouldHideSwipeOnTap:)]) {
//        hide = [_delegate swipeTableCell:self shouldHideSwipeOnTap:[recognizer locationInView:self]];
//    }
//    if (hide) {
//        [self hideSwipeAnimated:YES];
//    }
//}
//
//-(CGFloat) filterSwipe: (CGFloat) offset
//{
//    bool allowed = offset > 0 ? _allowSwipeLeftToRight : _allowSwipeRightToLeft;
//    UIView * buttons = offset > 0 ? _leftView : _rightView;
//    if (!buttons || ! allowed) {
//        offset = 0;
//    }
//    else if (!_allowsOppositeSwipe && _firstSwipeState == MGSwipeStateSwipingLeftToRight && offset < 0) {
//        offset = 0;
//    }
//    else if (!_allowsOppositeSwipe && _firstSwipeState == MGSwipeStateSwipingRightToLeft && offset > 0 ) {
//        offset = 0;
//    }
//    return offset;
//}
//
//-(void) panHandler: (UIPanGestureRecognizer *)gesture
//{
//    CGPoint current = [gesture translationInView:self];
//
//    if (gesture.state == UIGestureRecognizerStateBegan) {
//        [self invalidateDisplayLink];
//
//        if (!_preservesSelectionStatus)
//        self.highlighted = NO;
//        [self createSwipeViewIfNeeded];
//        _panStartPoint = current;
//        _panStartOffset = _swipeOffset;
//        if (_swipeOffset != 0) {
//            _firstSwipeState = _swipeOffset > 0 ? MGSwipeStateSwipingLeftToRight : MGSwipeStateSwipingRightToLeft;
//        }
//
//        if (!_allowsMultipleSwipe) {
//            NSArray * cells = [self parentTable].visibleCells;
//            for (MGSwipeTableCell * cell in cells) {
//                if ([cell isKindOfClass:[MGSwipeTableCell class]] && cell != self) {
//                    [cell cancelPanGesture];
//                }
//            }
//        }
//    }
//    else if (gesture.state == UIGestureRecognizerStateChanged) {
//        CGFloat offset = _panStartOffset + current.x - _panStartPoint.x;
//        if (_firstSwipeState == MGSwipeStateNone) {
//            _firstSwipeState = offset > 0 ? MGSwipeStateSwipingLeftToRight : MGSwipeStateSwipingRightToLeft;
//        }
//        self.swipeOffset = [self filterSwipe:offset];
//    }
//    else {
//        __weak MGSwipeButtonsView * expansion = _activeExpansion;
//        if (expansion) {
//            __weak UIView * expandedButton = [expansion getExpandedButton];
//            MGSwipeExpansionSettings * expSettings = _swipeOffset > 0 ? _leftExpansion : _rightExpansion;
//            UIColor * backgroundColor = nil;
//            if (!expSettings.fillOnTrigger && expSettings.expansionColor) {
//                backgroundColor = expansion.backgroundColorCopy; //keep expansion background color
//                expansion.backgroundColorCopy = expSettings.expansionColor;
//            }
//            [self setSwipeOffset:_targetOffset animation:expSettings.triggerAnimation completion:^(BOOL finished){
//                if (!finished || self.hidden || !expansion) {
//                return; //cell might be hidden after a delete row animation without being deallocated (to be reused later)
//                }
//                BOOL autoHide = [expansion handleClick:expandedButton fromExpansion:YES];
//                if (autoHide) {
//                [expansion endExpansionAnimated:NO];
//                }
//                if (backgroundColor && expandedButton) {
//                expandedButton.backgroundColor = backgroundColor;
//                }
//                }];
//        }
//        else {
//            CGFloat velocity = [_panRecognizer velocityInView:self].x;
//            CGFloat inertiaThreshold = 100.0; //points per second
//
//            if (velocity > inertiaThreshold) {
//                _targetOffset = _swipeOffset < 0 ? 0 : (_leftView  && _leftSwipeSettings.keepButtonsSwiped ? _leftView.bounds.size.width : _targetOffset);
//            }
//            else if (velocity < -inertiaThreshold) {
//                _targetOffset = _swipeOffset > 0 ? 0 : (_rightView && _rightSwipeSettings.keepButtonsSwiped ? -_rightView.bounds.size.width : _targetOffset);
//            }
//            _targetOffset = [self filterSwipe:_targetOffset];
//            MGSwipeSettings * settings = _swipeOffset > 0 ? _leftSwipeSettings : _rightSwipeSettings;
//            MGSwipeAnimation * animation = nil;
//            if (_targetOffset == 0) {
//                animation = settings.hideAnimation;
//            }
//            else if (fabs(_swipeOffset) > fabs(_targetOffset)) {
//                animation = settings.stretchAnimation;
//            }
//            else {
//                animation = settings.showAnimation;
//            }
//            [self setSwipeOffset:_targetOffset animation:animation completion:nil];
//        }
//
//        _firstSwipeState = MGSwipeStateNone;
//    }
//    }
//
//    - (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
//
//        if (gestureRecognizer == _panRecognizer) {
//
//            if (self.isEditing) {
//                return NO; //do not swipe while editing table
//            }
//
//            CGPoint translation = [_panRecognizer translationInView:self];
//            if (fabs(translation.y) > fabs(translation.x)) {
//                return NO; // user is scrolling vertically
//            }
//            if (_swipeView) {
//                CGPoint point = [_tapRecognizer locationInView:_swipeView];
//                if (!CGRectContainsPoint(_swipeView.bounds, point)) {
//                    return _allowsSwipeWhenTappingButtons; //user clicked outside the cell or in the buttons area
//                }
//            }
//
//            if (_swipeOffset != 0.0) {
//                return YES; //already swiped, don't need to check buttons or canSwipe delegate
//            }
//
//            //make a decision according to existing buttons or using the optional delegate
//            if (_delegate && [_delegate respondsToSelector:@selector(swipeTableCell:canSwipe:fromPoint:)]) {
//                CGPoint point = [_panRecognizer locationInView:self];
//                _allowSwipeLeftToRight = [_delegate swipeTableCell:self canSwipe:MGSwipeDirectionLeftToRight fromPoint:point];
//                _allowSwipeRightToLeft = [_delegate swipeTableCell:self canSwipe:MGSwipeDirectionRightToLeft fromPoint:point];
//            }
//            else if (_delegate && [_delegate respondsToSelector:@selector(swipeTableCell:canSwipe:)]) {
//                #pragma clang diagnostic push
//                #pragma clang diagnostic ignored "-Wdeprecated-declarations"
//                _allowSwipeLeftToRight = [_delegate swipeTableCell:self canSwipe:MGSwipeDirectionLeftToRight];
//                _allowSwipeRightToLeft = [_delegate swipeTableCell:self canSwipe:MGSwipeDirectionRightToLeft];
//                #pragma clang diagnostic pop
//            }
//            else {
//                [self fetchButtonsIfNeeded];
//                _allowSwipeLeftToRight = _leftButtons.count > 0;
//                _allowSwipeRightToLeft = _rightButtons.count > 0;
//            }
//
//            return (_allowSwipeLeftToRight && translation.x > 0) || (_allowSwipeRightToLeft && translation.x < 0);
//        }
//        else if (gestureRecognizer == _tapRecognizer) {
//            CGPoint point = [_tapRecognizer locationInView:_swipeView];
//            return CGRectContainsPoint(_swipeView.bounds, point);
//        }
//        return YES;
//}
//
//-(BOOL) isSwipeGestureActive
//    {
//        return _panRecognizer.state == UIGestureRecognizerStateBegan || _panRecognizer.state == UIGestureRecognizerStateChanged;
//}
//
//-(void)setSwipeBackgroundColor:(UIColor *)swipeBackgroundColor {
//    _swipeBackgroundColor = swipeBackgroundColor;
//    if (_swipeOverlay) {
//        _swipeOverlay.backgroundColor = swipeBackgroundColor;
//    }
//}
//
//@end

//MARK: Accessibility
extension WWSwipeView {
    override func accessibilityElementCount() -> Int {
        return self.swipeOffset == 0 ? super.accessibilityElementCount() : 1
    }
    
    override func accessibilityElement(at index: Int) -> Any? {
        return self.swipeOffset == 0 ? super.accessibilityElement(at: index) : self
    }
    
    override func index(ofAccessibilityElement element: Any) -> Int {
        return self.swipeOffset == 0 ? super.index(ofAccessibilityElement: element) : 0
    }
}
