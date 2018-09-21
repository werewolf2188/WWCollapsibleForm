//
//  WWSection.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
public class WWSection : NSObject {
  
    private struct WWViewInfo {
        var row : Int
        var view: UIView
        var height : CGFloat
        var autoCollapse : Bool
    }
    
    public enum WWStatus : Int {
        case disabled
        case enabled
        case selected
    }
    public var status : WWStatus = .disabled
    
    private var _headerView : UIView!
    private var _selectedHeaderView : UIView!
    private var views : [WWViewInfo] = [] //Transform this into either class or struct

    internal var header : WWViewRepresentation?
    internal var selectedHeader : WWViewRepresentation!
    internal var template: WWViewRepresentation!
    internal var data : [WWDataObject] = []
    
    internal override init() {
        super.init()
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
        return self.views.count
    }
    
    internal func getHeight(row: Int) -> CGFloat {
        return self.views.filter({ $0.row == row }).first?.height ?? 0
    }
    
    internal func shouldAutoCollapse(row: Int) -> Bool {
        return self.views.filter({ $0.row == row }).first?.autoCollapse ?? false
    }
    
    internal func addView(form: WWCollapsibleForm, cell: UITableViewCell, row: Int) -> UIView? {
        
        if (self.data[row] is WWTemplateDataObject) {            
            let childrenView : UIView = self.views[row].view
            childrenView.frame = cell.bounds
            childrenView.tag = form.itemTag
            (childrenView as? WWItemView)?.reference = form
            (childrenView as? WWItemView)?.applyStatus(status: self.status)
            cell.contentView.addSubViewWithConstraints(childrenView)
            if (row != self.data.count - 1){
                UIView.addSeparator(subView: childrenView)
            }
            return childrenView
        }
        return nil
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
        var view : UIView = UIView()
        var height : CGFloat = 0
        if (data is WWTemplateDataObject) {
            view = template.createView()
            height = template.height
            
        } else if (data is WWNonTemplateDataObject) {
            view = (data as? WWNonTemplateDataObject)?.template.createView() ?? UIView()
            height = (data as? WWNonTemplateDataObject)?.template.height ?? 0
        }
        self.views.append(WWViewInfo(row: self.data.count, view: view, height: height, autoCollapse: data.autoCollapse))
        self.data.append(data)
        
    }
    
    private func initialize(template: WWViewRepresentation, selectedHeader: WWViewRepresentation) {
        self.template = template
        self.selectedHeader = selectedHeader
    }
}
