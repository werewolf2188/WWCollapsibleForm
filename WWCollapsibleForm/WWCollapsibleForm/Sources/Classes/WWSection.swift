//
//  WWSection.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

/// This class is the container of all the information regarding a section of a form. It represents a section that can be enabled, disabled or selected during the flow of the form. The form needs to have at least one section to render and the first one will always be enabled while the rest will be disabled.
public class WWSection : NSObject {
    
    /// This enumeration represent the different states of a section.
    public enum WWStatus : Int {
        /// When the state is disabled, the section will called the disable decorator on the headers and items to modify its style accordingly.
        case disabled
        /// When the state is enabled, the section will called the enable decorator on the headers and items to modify its style accordingly.
        case enabled
        /// When the state is selected, only the selected header will appear.
        case selected
    }
    
    /// Represents the status and any moment. Default: disabled.
    public var status : WWStatus = .disabled
    /// If the section gets enabled and this propety is true, all subsequent sections will be disabled.
    public var resetOnForward : Bool = false
    /// If this propety is set to true, and the section is selected, it wont be modified when a section with the property `resetOnForward` at true, gets enabled again.
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
            return parent.view.isUserInteractionEnabled &&
                (parent.data as? WWSubGroupDataObject)?.collapse == .byCell
        }
        return false
    }
    
    internal func changeSubGroup(row : Int) -> [IndexPath]? {
        if let parent = self.views[row] as? WWParentViewInfo {
            parent.isCollapsed = !parent.isCollapsed
            (parent.view as? WWItemView)?.isCollapsed = parent.isCollapsed
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
        
        cell.contentView.addSubViewWithConstraints(self.applyOptions(to: childrenView, data: self.views[row].data, row: row),
                                                   edgeInsets: UIEdgeInsets(top: 0,
                                                                            left: CGFloat(self.views[row].level ?? 0) * self.leftSpacing,
                                                                            bottom: 0,
                                                                            right: 0))
        cell.contentView.backgroundColor = childrenView.backgroundColor
        self.setSeparator(childrenView: childrenView, row: row, configuration: form.configuration)
        
        if let subGroup = self.views[row].data as? WWSubGroupDataObject,
            subGroup.collapse == .byButton {
            
            (childrenView as? WWItemView)?.subGroupButton?.actionHandle(controlEvents: .touchUpInside, forAction: {
                if (childrenView.isUserInteractionEnabled), let indexPath = (childrenView as? WWItemView)?.indexPath {
                    
                    if let items = self.changeSubGroup(row: indexPath.row) {
                        form.tableView.beginUpdates()
                        form.tableView.reloadRows(at:  [indexPath], with: .none)
                        form.tableView.reloadRows(at: items, with: .bottom)
                        form.tableView.endUpdates()
                    }
                }
            })
            
        }
        return childrenView
    }
    
    internal func applyOptions(to childrenView: UIView, data: WWDataObject, row: Int) -> UIView {
        if data.options.count > 0 {
            let optionsView : WWSwipeView = WWSwipeView(options: data.options)
            optionsView.swipeContentView.addSubViewWithConstraints(childrenView)
            optionsView.tag = childrenView.tag
            childrenView.tag = 0
            if let delegate = childrenView as? WWSwipeViewDelegate {
                optionsView.delegate = delegate
            }
            return optionsView
        }
        return childrenView
    }
    
    internal func getDataObject(row: Int) -> WWDataObject {
        return self.views[row].data
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
    
    internal func removeItem(form: WWCollapsibleForm, indexPath: IndexPath, dataObject: WWDataObject) {
        if (!(dataObject is WWSubGroupDataObject)) {
            self.removeOneItem(form: form, indexPath: indexPath, dataObject: dataObject)
        } else if let subGroupDataObject = dataObject as? WWSubGroupDataObject {
            self.removeGroupItem(form: form, indexPath: indexPath, dataObject: subGroupDataObject)
        }
    }
    
    private func removeOneItem(form: WWCollapsibleForm, indexPath: IndexPath, dataObject: WWDataObject) {
        let dataIndex : Int = self.data.firstIndex { (object) -> Bool in
            return object == dataObject
            } ?? -1
        let viewIndex : Int = self.views.firstIndex { (object) -> Bool in
            return object.data == dataObject
            } ?? -1
        
        if dataIndex != -1 && viewIndex != -1 {
            self.data.remove(at: dataIndex)
            self.views.remove(at: viewIndex)
            self.views.forEach { (viewInfo) in
                if let itemView = viewInfo.view as? WWItemView {
                    if itemView.indexPath.row > indexPath.row {
                        itemView.indexPath = IndexPath(row: itemView.indexPath.row - 1, section: self.section)
                    }
                }
            }
            form.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    private func removeGroupItem(form: WWCollapsibleForm, indexPath: IndexPath, dataObject: WWSubGroupDataObject) {
        let dataIndex : Int = self.data.firstIndex { (object) -> Bool in
            return object == dataObject
            } ?? -1
        var viewIndex : [Int] = [self.views.firstIndex { (object) -> Bool in
            return object.data == dataObject
            } ?? -1]
        if dataIndex != -1 && viewIndex[0] != -1 {
            var tempIndexPath : [IndexPath] = [indexPath]
            viewIndex.append(contentsOf: self.getViewIndexes(dataObjects: dataObject.data))
            for index in viewIndex {
                if index == viewIndex[0] {
                    continue
                }
                tempIndexPath.append((self.views[index].view as? WWItemView)?.indexPath ?? IndexPath(row: -1, section: self.section))
            }
            tempIndexPath.sort()
            self.data.remove(at: dataIndex)
            for index in viewIndex.reversed() {
                self.views.remove(at: index)
            }
            self.views.forEach { (viewInfo) in
                if let itemView = viewInfo.view as? WWItemView, let lastIndexPath = tempIndexPath.last {
                    if itemView.indexPath.row > lastIndexPath.row {
                        itemView.indexPath = IndexPath(row: itemView.indexPath.row - tempIndexPath.count, section: self.section)
                    }
                }
            }
            form.tableView.deleteRows(at: tempIndexPath, with: .automatic)
        }
    }
    
    private func getViewIndexes(dataObjects : [WWDataObject]) -> [Int] {
        var viewIndex : [Int] = []
        for dataObject in dataObjects {
            viewIndex.append(self.views.firstIndex { (object) -> Bool in
                return object.data == dataObject
                } ?? -1)
            if let subGroupDataObject = dataObject as? WWSubGroupDataObject{
                viewIndex.append(contentsOf: self.getViewIndexes(dataObjects: subGroupDataObject.data))
            }
        }
        return viewIndex
    }
    
    /// Initializes a section with a header template, an item template and a selected item template that will be use. The item template will be use only in data objects of type `WWTemplateDataObject`.
    /// - Parameters:
    ///     - header: The template that will be used for headers.
    ///     - template: The template that will be used for items that are related to a data object of type WWTemplateDataObject.
    ///     - selectedHeader: The template that will be used for selected headers.
    public convenience init(header: WWViewRepresentation?, template: WWViewRepresentation, selectedHeader: WWViewRepresentation) {
        self.init()
        self.header = header
        self.initialize(template: template, selectedHeader: selectedHeader)
    }
    
    /// Initializes a section with an item template and a selected item template that will be use. The item template will be use only in data objects of type `WWTemplateDataObject`.
    /// - Parameters:
    ///     - template: The template that will be used for items that are related to a data object of type WWTemplateDataObject.
    ///     - selectedHeader: The template that will be used for selected headers.
    public convenience init(template: WWViewRepresentation, selectedHeader: WWViewRepresentation) {
        self.init()
        self.initialize(template: template, selectedHeader: selectedHeader)
    }
    
    /// Adds a new data object to the process. This function should be called during loading time.
    /// - Parameter data: the data object to be appended.
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
    
    private func setSeparator(childrenView: UIView, row: Int, configuration: WWCollapsibleFormConfiguration) {
        //It does not have any parents
        childrenView.removeSeparator()
        if (self.views.filter({ $0 is WWParentViewInfo }).count == 0) {
            if (row != self.views.count - 1) {
                UIView.addSeparator(subView: childrenView, color: configuration.separatorColor, leading: configuration.separatorLeading, trailing: configuration.separatorTrailing)
            }
        } else {
            let numberOfParents : Int = self.views.filter({ $0 is WWParentViewInfo }).count
            self.views.enumerated().forEach { (arg0) in
                
                let (index, element) = arg0
                if (index == row) {
                    if let parent = element as? WWParentViewInfo,
                        let indexOfParent = self.views.firstIndex(of: self.views[row]),
                        parent.isCollapsed && indexOfParent < (numberOfParents - 1) {
                        UIView.addSeparator(subView: childrenView, color: configuration.separatorColor, leading: configuration.separatorLeading, trailing: configuration.separatorTrailing)
                    } else if let lastIndexPath = (element.parent?.children?.last?.view as? WWItemView)?.indexPath,
                        let indexPath = (element.view as? WWItemView)?.indexPath,
                        indexPath != lastIndexPath {
                        UIView.addSeparator(subView: childrenView, color: configuration.separatorColor, leading: configuration.separatorLeading, trailing: configuration.separatorTrailing)
                    }
                }
            }
            
        }
    }
}
