//
//  WWSection.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/15/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
public class WWSection : NSObject {
    /// header
    
    public enum WWStatus : Int {
        case disabled
        case enabled
        case selected
    }
    public var status : WWStatus = .disabled
    public var footer: WWViewRepresentation?
    
    private var _headerView : UIView!
    private var _selectedHeaderView : UIView!
    private var _footerView : UIView? = nil
    private var views : [(Int, UIView, CGFloat)] = []

    internal var header : WWViewRepresentation?
    internal var selectedHeader : WWViewRepresentation!
    internal var template: WWViewRepresentation!
    internal var data : [WWDataObject] = []
    
    internal override init() {
        super.init()
    }
    
    internal func getHeader() -> UIView {
        if (status != .selected) {
            if _headerView == nil {
                _headerView = self.header?.createView()
            }
            return _headerView
        } else {
            if _selectedHeaderView == nil {
                _selectedHeaderView = self.selectedHeader?.createView()
            }
            return _selectedHeaderView
        }
    }
    
    internal func getFooter() -> UIView? {
        if (self.status != .selected) {
            if let footer = self.footer?.createView() {
                
                _footerView = footer
            } else {
                let footer : UIView = UIView()
                footer.backgroundColor = self.getHeader().backgroundColor
                
                _footerView = footer
            }
        } else {
            _footerView = nil
        }
        return _footerView
    }
    
    internal func getRows() -> Int {
        if self.status == .selected {
            return 0
        }
        return self.views.count
    }
    
    internal func getHeight(row: Int) -> CGFloat {
        return self.views.filter({ $0.0 == row }).first?.2 ?? 0
    }
    
    internal func addView(form: WWCollapsibleForm, cell: UITableViewCell, row: Int) {
        
        if (self.data[row] is WWTemplateDataObject) {
            let childrenView : UIView = self.template.createView()
            childrenView.tag = form.itemTag
            (childrenView as? WWItemView)?.reference = form
            cell.contentView.addSubViewWithConstraints(childrenView)
            if (row != self.data.count - 1){
                UIView.addSeparator(subView: childrenView)
            }
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
        var view : UIView = UIView()
        var height : CGFloat = 0
        if (data is WWTemplateDataObject) {
            view = template.createView()
            height = template.height
            
        } else if (data is WWNonTemplateDataObject) {
            view = (data as? WWNonTemplateDataObject)?.template.createView() ?? UIView()
            height = (data as? WWNonTemplateDataObject)?.template.height ?? 0
        }
        self.views.append((self.data.count, view, height))
        self.data.append(data)
        
    }
    
    private func initialize(template: WWViewRepresentation, selectedHeader: WWViewRepresentation) {
        self.template = template
        self.selectedHeader = selectedHeader
    }
    
}
