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
//#pragma mark Handle Table Events
//
//-(void) prepareForReuse
//    {
//        [super prepareForReuse];
//        [self cleanViews];
//        if (_swipeState != MGSwipeStateNone) {
//            _triggerStateChanges = YES;
//            [self updateState:MGSwipeStateNone];
//        }
//        BOOL cleanButtons = _delegate && [_delegate respondsToSelector:@selector(swipeTableCell:swipeButtonsForDirection:swipeSettings:expansionSettings:)];
//        [self initViews:cleanButtons];
//}
//
//-(void) setEditing:(BOOL)editing animated:(BOOL)animated
//{
//    [super setEditing:editing animated:animated];
//    if (editing) { //disable swipe buttons when the user sets table editing mode
//        self.swipeOffset = 0;
//    }
//}
//
//-(void) setEditing:(BOOL)editing
//{
//    [super setEditing:YES];
//    if (editing) { //disable swipe buttons when the user sets table editing mode
//        self.swipeOffset = 0;
//    }
//}
//
//-(UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    if (!self.hidden && _swipeOverlay && !_swipeOverlay.hidden) {
//        //override hitTest to give swipe buttons a higher priority (diclosure buttons can steal input)
//        UIView * targets[] = {_leftView, _rightView};
//        for (int i = 0; i< 2; ++i) {
//            UIView * target = targets[i];
//            if (!target) continue;
//
//            CGPoint p = [self convertPoint:point toView:target];
//            if (CGRectContainsPoint(target.bounds, p)) {
//                return [target hitTest:p withEvent:event];
//            }
//        }
//    }
//    return [super hitTest:point withEvent:event];
//}
//
//#pragma mark Some utility methods
//
//
//
//-(UITableView *) parentTable
//    {
//        UIView * view = self.superview;
//        while(view != nil) {
//            if([view isKindOfClass:[UITableView class]]) {
//                return (UITableView*) view;
//            }
//            view = view.superview;
//        }
//        return nil;
//}
//
//-(void) updateState: (MGSwipeState) newState;
//{
//    if (!_triggerStateChanges || _swipeState == newState) {
//        return;
//    }
//    _swipeState = newState;
//    if (_delegate && [_delegate respondsToSelector:@selector(swipeTableCell:didChangeSwipeState:gestureIsActive:)]) {
//        [_delegate swipeTableCell:self didChangeSwipeState:_swipeState gestureIsActive: self.isSwipeGestureActive] ;
//    }
//}
//
//#pragma mark Swipe Animation
//
//- (void)setSwipeOffset:(CGFloat) newOffset;
//{
//    CGFloat sign = newOffset > 0 ? 1.0 : -1.0;
//    MGSwipeButtonsView * activeButtons = sign < 0 ? _rightView : _leftView;
//    MGSwipeSettings * activeSettings = sign < 0 ? _rightSwipeSettings : _leftSwipeSettings;
//
//    if(activeSettings.enableSwipeBounces) {
//        _swipeOffset = newOffset;
//
//        CGFloat maxUnbouncedOffset = sign * activeButtons.bounds.size.width;
//
//        if ((sign > 0 && newOffset > maxUnbouncedOffset) || (sign < 0 && newOffset < maxUnbouncedOffset)) {
//            _swipeOffset = maxUnbouncedOffset + (newOffset - maxUnbouncedOffset) * activeSettings.swipeBounceRate;
//        }
//    }
//    else {
//        CGFloat maxOffset = sign * activeButtons.bounds.size.width;
//        _swipeOffset = sign > 0 ? MIN(newOffset, maxOffset) : MAX(newOffset, maxOffset);
//    }
//    CGFloat offset = fabs(_swipeOffset);
//
//
//    if (!activeButtons || offset == 0) {
//        if (_leftView)
//        [_leftView endExpansionAnimated:NO];
//        if (_rightView)
//        [_rightView endExpansionAnimated:NO];
//        [self hideSwipeOverlayIfNeeded];
//        _targetOffset = 0;
//        [self updateState:MGSwipeStateNone];
//        return;
//    }
//    else {
//        [self showSwipeOverlayIfNeeded];
//        CGFloat swipeThreshold = activeSettings.threshold;
//        BOOL keepButtons = activeSettings.keepButtonsSwiped;
//        _targetOffset = keepButtons && offset > activeButtons.bounds.size.width * swipeThreshold ? activeButtons.bounds.size.width * sign : 0;
//    }
//
//    BOOL onlyButtons = activeSettings.onlySwipeButtons;
//    UIEdgeInsets safeInsets = [self getSafeInsets];
//    CGFloat safeInset = [self isRTLLocale] ? safeInsets.right :  -safeInsets.left;
//    _swipeView.transform = CGAffineTransformMakeTranslation(safeInset + (onlyButtons ? 0 : _swipeOffset), 0);
//
//    //animate existing buttons
//    MGSwipeButtonsView* but[2] = {_leftView, _rightView};
//    MGSwipeSettings* settings[2] = {_leftSwipeSettings, _rightSwipeSettings};
//    MGSwipeExpansionSettings * expansions[2] = {_leftExpansion, _rightExpansion};
//
//    for (int i = 0; i< 2; ++i) {
//        MGSwipeButtonsView * view = but[i];
//        if (!view) continue;
//
//        //buttons view position
//        CGFloat translation = MIN(offset, view.bounds.size.width) * sign + settings[i].offset * sign;
//        view.transform = CGAffineTransformMakeTranslation(translation, 0);
//
//        if (view != activeButtons) continue; //only transition if active (perf. improvement)
//        bool expand = expansions[i].buttonIndex >= 0 && offset > view.bounds.size.width * expansions[i].threshold;
//        if (expand) {
//            [view expandToOffset:offset settings:expansions[i]];
//            _targetOffset = expansions[i].fillOnTrigger ? self.bounds.size.width * sign : 0;
//            _activeExpansion = view;
//            [self updateState:i ? MGSwipeStateExpandingRightToLeft : MGSwipeStateExpandingLeftToRight];
//        }
//        else {
//            [view endExpansionAnimated:YES];
//            _activeExpansion = nil;
//            CGFloat t = MIN(1.0f, offset/view.bounds.size.width);
//            [view transition:settings[i].transition percent:t];
//            [self updateState:i ? MGSwipeStateSwipingRightToLeft : MGSwipeStateSwipingLeftToRight];
//        }
//    }
//}
//
//-(void) hideSwipeAnimated: (BOOL) animated completion:(void(^)(BOOL finished)) completion
//{
//    MGSwipeAnimation * animation = animated ? (_swipeOffset > 0 ? _leftSwipeSettings.hideAnimation: _rightSwipeSettings.hideAnimation) : nil;
//    [self setSwipeOffset:0 animation:animation completion:completion];
//}
//
//-(void) hideSwipeAnimated: (BOOL) animated
//{
//    [self hideSwipeAnimated:animated completion:nil];
//}
//
//-(void) showSwipe: (MGSwipeDirection) direction animated: (BOOL) animated
//{
//    [self showSwipe:direction animated:animated completion:nil];
//}
//
//-(void) showSwipe: (MGSwipeDirection) direction animated: (BOOL) animated completion:(void(^)(BOOL finished)) completion
//{
//    [self createSwipeViewIfNeeded];
//    _allowSwipeLeftToRight = _leftButtons.count > 0;
//    _allowSwipeRightToLeft = _rightButtons.count > 0;
//    UIView * buttonsView = direction == MGSwipeDirectionLeftToRight ? _leftView : _rightView;
//
//    if (buttonsView) {
//        CGFloat s = direction == MGSwipeDirectionLeftToRight ? 1.0 : -1.0;
//        MGSwipeAnimation * animation = animated ? (direction == MGSwipeDirectionLeftToRight ? _leftSwipeSettings.showAnimation : _rightSwipeSettings.showAnimation) : nil;
//        [self setSwipeOffset:buttonsView.bounds.size.width * s animation:animation completion:completion];
//    }
//}
//
//-(void) expandSwipe: (MGSwipeDirection) direction animated: (BOOL) animated
//{
//    CGFloat s = direction == MGSwipeDirectionLeftToRight ? 1.0 : -1.0;
//    MGSwipeExpansionSettings* expSetting = direction == MGSwipeDirectionLeftToRight ? _leftExpansion : _rightExpansion;
//
//    // only perform animation if there's no pending expansion animation and requested direction has fillOnTrigger enabled
//    if(!_activeExpansion && expSetting.fillOnTrigger) {
//        [self createSwipeViewIfNeeded];
//        _allowSwipeLeftToRight = _leftButtons.count > 0;
//        _allowSwipeRightToLeft = _rightButtons.count > 0;
//        UIView * buttonsView = direction == MGSwipeDirectionLeftToRight ? _leftView : _rightView;
//
//        if (buttonsView) {
//            __weak MGSwipeButtonsView * expansionView = direction == MGSwipeDirectionLeftToRight ? _leftView : _rightView;
//            __weak MGSwipeTableCell * weakself = self;
//            [self setSwipeOffset:buttonsView.bounds.size.width * s * expSetting.threshold * 2 animation:expSetting.triggerAnimation completion:^(BOOL finished){
//                [expansionView endExpansionAnimated:YES];
//                [weakself setSwipeOffset:0 animated:NO completion:nil];
//                }];
//        }
//    }
//}
//
//-(void) animationTick: (CADisplayLink *) timer
//{
//    if (!_animationData.start) {
//        _animationData.start = timer.timestamp;
//    }
//    CFTimeInterval elapsed = timer.timestamp - _animationData.start;
//    bool completed = elapsed >= _animationData.duration;
//    if (completed) {
//        _triggerStateChanges = YES;
//    }
//    self.swipeOffset = [_animationData.animation value:elapsed duration:_animationData.duration from:_animationData.from to:_animationData.to];
//
//    //call animation completion and invalidate timer
//    if (completed){
//        [timer invalidate];
//        [self invalidateDisplayLink];
//    }
//}
//
//-(void)invalidateDisplayLink {
//    [_displayLink invalidate];
//    _displayLink = nil;
//    if (_animationCompletion) {
//        void (^callbackCopy)(BOOL finished) = _animationCompletion; //copy to avoid duplicated callbacks
//        _animationCompletion = nil;
//        callbackCopy(YES);
//    }
//}
//
//-(void) setSwipeOffset:(CGFloat)offset animated: (BOOL) animated completion:(void(^)(BOOL finished)) completion
//{
//    MGSwipeAnimation * animation = animated ? [[MGSwipeAnimation alloc] init] : nil;
//    [self setSwipeOffset:offset animation:animation completion:completion];
//}
//
//-(void) setSwipeOffset:(CGFloat)offset animation: (MGSwipeAnimation *) animation completion:(void(^)(BOOL finished)) completion
//{
//    if (_displayLink) {
//        [_displayLink invalidate];
//        _displayLink = nil;
//    }
//    if (_animationCompletion) { //notify previous animation cancelled
//        void (^callbackCopy)(BOOL finished) = _animationCompletion; //copy to avoid duplicated callbacks
//        _animationCompletion = nil;
//        callbackCopy(NO);
//    }
//    if (offset !=0) {
//        [self createSwipeViewIfNeeded];
//    }
//
//    if (!animation) {
//        self.swipeOffset = offset;
//        if (completion) {
//            completion(YES);
//        }
//        return;
//    }
//
//    _animationCompletion = completion;
//    _triggerStateChanges = NO;
//    _animationData.from = _swipeOffset;
//    _animationData.to = offset;
//    _animationData.duration = animation.duration;
//    _animationData.start = 0;
//    _animationData.animation = animation;
//    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(animationTick:)];
//    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
//}
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
