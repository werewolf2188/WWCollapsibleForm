//
//  WWSection.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
public class WWSection : NSObject {
    
    public enum WWStatus : Int {
        case disabled
        case enabled
        case selected
    }
    public var status : WWStatus = .disabled
    public var resetOnForward : Bool = false
    public var unmutableOnceSelected : Bool = false
    
    private var _headerView : UIView!
    private var _selectedHeaderView : UIView!
    
    private var views : [WWViewInfo] = []
    private let leftSpacing : CGFloat = 20

    internal var header : WWViewRepresentation?
    internal var selectedHeader : WWViewRepresentation!
    internal var template: WWViewRepresentation!
    internal var data : [WWDataObject] = []
    internal var section : Int = -1
    
    internal override init() {
        super.init()
    }
    
    internal func getItemCount() -> Int {
        return self.views.count
    }
    
    internal func getHeader(section: Int, form : WWCollapsibleForm) -> UIView {
        if (status != .selected) {
            if _headerView == nil {
                _headerView = self.header?.createView()
                 (_headerView as? WWHeaderView)?.reference = form
                 (_headerView as? WWHeaderView)?.section = section
            }
            return _headerView
        } else {
            if _selectedHeaderView == nil {
                _selectedHeaderView = self.selectedHeader?.createView()
                (_selectedHeaderView as? WWHeaderView)?.reference = form
                 (_selectedHeaderView as? WWHeaderView)?.section = section
            }
            return _selectedHeaderView
        }
    }
   
    internal func getRows() -> Int {
        if self.status == .selected {
            return 0
        }
        return getItemCount()
    }
    
    internal func getHeight(row: Int) -> CGFloat {
        // Hiding the views is not the best thing ever. Need to figure it out something better.
        if let parent = self.views[row].parent,
            parent.isCollapsed {
            self.views[row].view.isHidden = true
            return 0
        }
        self.views[row].view.isHidden = false
        return self.views[row].height
    }
    
    internal func shouldAutoCollapse(row: Int) -> Bool {
        let autoCollapse = self.views[row].autoCollapse ?? false
        let isEnabled = self.views[row].view.isUserInteractionEnabled
        return autoCollapse && isEnabled
    }
    
    internal func isParentAndEnabled(row : Int) -> Bool {
        if let parent = self.views[row] as? WWParentViewInfo {
            return parent.view.isUserInteractionEnabled
        }
        return false
    }
    
    internal func changeSubGroup(row : Int) -> [IndexPath]? {
        if let parent = self.views[row] as? WWParentViewInfo {
            parent.isCollapsed = !parent.isCollapsed
            let items = parent.children?.map({ (info) -> IndexPath? in
                return (info.view as? WWItemView)?.indexPath
            }).filter({ $0 != nil}).map({ $0! })
            return items
        }
        return nil
    }
    
    internal func addView(form: WWCollapsibleForm, cell: UITableViewCell, row: Int) -> UIView? {
        let childrenView : UIView = self.views[row].view
        childrenView.frame = cell.bounds
        childrenView.tag = form.itemTag
        (childrenView as? WWItemView)?.reference = form
        (childrenView as? WWItemView)?.indexPath = IndexPath(row: row, section: self.section)
        (childrenView as? WWItemView)?.applyStatus(status: self.status)
        cell.contentView.addSubViewWithConstraints(childrenView, edgeInsets: UIEdgeInsets(top: 0, left: CGFloat(self.views[row].level ?? 0) * self.leftSpacing, bottom: 0, right: 0))
        cell.contentView.backgroundColor = childrenView.backgroundColor
        self.setSeparator(childrenView: childrenView, row: row)
        return childrenView
    }
    
    internal func addSeparatorToSelectedHeader() {
        
        if let _selectedHeaderView = self._selectedHeaderView {
            _selectedHeaderView.removeDiagonal()
            UIView.addSeparator(subView: _selectedHeaderView, color: UIColor.white)
        }
    }
    
    internal func removeSeparatorToSelectedHeader(onRemoved:(_ selectedHeader: UIView, _ section: Int) -> Void) {
        
        if let _selectedHeaderView = self._selectedHeaderView {
            _selectedHeaderView.removeSeparator()
            onRemoved(_selectedHeaderView, section)
        }
    }
    
    public convenience init(header: WWViewRepresentation?, template: WWViewRepresentation, selectedHeader: WWViewRepresentation) {
        self.init()
        self.header = header
        self.initialize(template: template, selectedHeader: selectedHeader)
    }
    
    public convenience init(template: WWViewRepresentation, selectedHeader: WWViewRepresentation) {
        self.init()
        self.initialize(template: template, selectedHeader: selectedHeader)
    }
    
    public func appendData(data: WWDataObject) {
        
        self.data.append(data)
        self.appendView(data: data)
    }
    
    func appendView(data: WWDataObject) {        
        if let builder : IWWViewInfoBuilder = IWWViewInfoBuilderFactory.getBuilder(dataObject: data) {
            let director : WWViewInfoBuilDirector = WWViewInfoBuilDirector(builder: builder)
            director.construct(section: self)
            self.views.append(contentsOf: builder.getResult())
        }
    }
    
    private func initialize(template: WWViewRepresentation, selectedHeader: WWViewRepresentation) {
        self.template = template
        self.selectedHeader = selectedHeader
    }
    
    private func setSeparator(childrenView: UIView, row: Int) {
        //It does not have any parents
        childrenView.removeSeparator()
        if (self.views.filter({ $0 is WWParentViewInfo }).count == 0) {
            if (row != self.views.count - 1) {
                UIView.addSeparator(subView: childrenView)
            }
        } else {
            let numberOfParents : Int = self.views.filter({ $0 is WWParentViewInfo }).count
            self.views.enumerated().forEach { (arg0) in
                
                let (index, element) = arg0
                if (index == row) {
                    if let parent = element as? WWParentViewInfo,
                        let indexOfParent = self.views.firstIndex(of: self.views[row]),
                        parent.isCollapsed && indexOfParent < (numberOfParents - 1) {
                        UIView.addSeparator(subView: childrenView)
                    } else if let lastIndexPath = (element.parent?.children?.last?.view as? WWItemView)?.indexPath,
                        let indexPath = (element.view as? WWItemView)?.indexPath,
                        indexPath != lastIndexPath {
                        UIView.addSeparator(subView: childrenView)
                    }
                }
            }
            
        }
    }
}
