//
//  WWCollapsibleForm.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 9/12/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
import UIKit

////
public class WWCollapsibleForm : UITableView {
    
    var sections : [WWSection] = []
    let cellString : String = "cell"
    let minimumFooterHeight : CGFloat = 20
    private func initialize() {        
        self.register(UITableViewCell.self, forCellReuseIdentifier: cellString)
        self.separatorStyle = .none
    }
    
    public init(frame: CGRect) {
        super.init(frame: frame, style: .grouped)
        self.initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    public override func didMoveToSuperview() {
        self.dataSource = self
        self.delegate = self
    }
    
    //Add new section
    public func append(section: WWSection) {
        self.sections.append(section)
    }
}

////
extension WWCollapsibleForm : UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.sections[section].status == .selected {
            return 0
        }
        return self.sections[section].data.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell = self.dequeueReusableCell(withIdentifier: cellString, for: indexPath)
        cell.selectionStyle = .none
        cell.viewWithTag(1)?.removeFromSuperview()
        
        return cell
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
}

////
extension WWCollapsibleForm : UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        /// optimize
        if (self.sections[indexPath.section].data[indexPath.row] is WWTemplateDataObject) {
            let childrenView : UIView = self.sections[indexPath.section].template.createView()
            childrenView.tag = 1
            (childrenView as? WWItemView)?.reference = self
            cell.contentView.addSubViewWithConstraints(childrenView)
            if (indexPath.row != self.sections[indexPath.section].data.count - 1){
                UIView.addSeparator(subView: childrenView)
            }
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header : UIView = self.sections[section].getHeader()
        (header as? WWHeaderFooterView)?.reference = self
        (header as? WWHeaderFooterView)?.section = section
        return header
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer : UIView? = self.sections[section].getFooter()
        (footer as? WWHeaderFooterView)?.reference = self
        (footer as? WWHeaderFooterView)?.section = section
        return footer
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.sections[section].header?.height ?? UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (self.sections[section].status != .selected) {
            return self.sections[section].footer?.height ?? minimumFooterHeight
        }
        return 1
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (self.sections[indexPath.section].data[indexPath.row] is WWTemplateDataObject) {
            return self.sections[indexPath.section].template.height
        }
        return 0
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("hello")
        if (self.sections[indexPath.section].data[indexPath.row].autoCollapse) {
            self.collapse(indexPath: indexPath)
        }
    }
}

extension WWCollapsibleForm {
    func collapse(indexPath: IndexPath) {
        self.collapse(section: indexPath.section)
    }
    
    func collapse(section : Int) {
        self.sections[section].status = .selected
        self.reloadSections([section], with: .fade)
    }
    
    func expand(indexPath: IndexPath) {
        self.expand(section: indexPath.section)
    }
    
    func expand(section : Int) {
        self.sections[section].status = .enabled
        self.reloadSections([section], with: .fade)
    }
}

////
public class WWSection : NSObject {
    /// header
    
    public enum WWStatus : Int {
        case disabled
        case enabled
        case selected
    }
    
    public var status : WWStatus = .disabled
    internal var header : WWViewRepresentation?
    /// selected header
    internal var selectedHeader : WWViewRepresentation!
    /// template
    internal var template: WWViewRepresentation!
    
    private var _headerView : UIView!
    private var _selectedHeaderView : UIView!
    private var _footerView : UIView? = nil
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
    
    internal override init() {
        super.init()
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
    
    private func initialize(template: WWViewRepresentation, selectedHeader: WWViewRepresentation) {
        self.template = template
        self.selectedHeader = selectedHeader
    }
    
    /// footer
    public var footer: WWViewRepresentation?
    
    /// data
    public var data : [WWDataObject] = []
}

///
public class WWViewRepresentation : NSObject {
    public var height : CGFloat = UITableViewAutomaticDimension
    var bundle : Bundle!
    var viewName : String!
    
    public init(view: WWItemView, height: CGFloat = UITableViewAutomaticDimension) {
        super.init()
        self.bundle = Bundle(for: type(of: view))
        self.viewName = String(describing: type(of: view))
        if (height == UITableViewAutomaticDimension) {
            self.height = self.createView().frame.size.height
        }
        else {
            self.height = height
        }
    }
    
    public init(headerFooterView: WWHeaderFooterView) {
        super.init()
        self.bundle = Bundle(for: type(of: headerFooterView))
        self.viewName = String(describing: type(of: headerFooterView))
        self.height = self.createView().frame.size.height
    }
    
    func createView() -> UIView {
        return self.bundle.loadNibNamed(self.viewName, owner: nil, options: nil)?.first as? UIView ?? UIView()
    }
}

///
public class WWDataObject : NSObject {
    public var autoCollapse : Bool = true
    
    override init() {
        super.init()
    }
}

public class WWTemplateDataObject : WWDataObject {
    public override init() {
        super.init()
    }
}

public class WWNonTemplateDataObject : WWDataObject {
    var template: WWViewRepresentation!
    override init() {
        super.init()
    }
    
    public convenience init(view: WWItemView, height: CGFloat = UITableViewAutomaticDimension) {
        self.init()
        self.template = WWViewRepresentation (view: view, height: height)
    }
}

/// Status Decorator
public class WWStatusDecorator : NSObject {
    var decoratorFunction : ((_:UIView) -> Void)?
    
    public init(decoratorFunction: @escaping ((_:UIView) -> Void)) {
        super.init()
        self.decoratorFunction = decoratorFunction
    }
    
    public func decorate(view : UIView) {
        self.decoratorFunction?(view)
    }
}

///
open class WWItemView : UIView {
    internal var reference: WWCollapsibleForm!
    internal var indexPath: IndexPath!
    
    public var enableDecorator: WWStatusDecorator?
    public var disableDecorator: WWStatusDecorator?
    
    public func collapse() {
        self.reference.collapse(indexPath: indexPath)
    }
}

open class WWHeaderFooterView: UIView {
    internal var reference: WWCollapsibleForm!
    internal var section : Int!
    
    public var enableDecorator: WWStatusDecorator?
    public var disableDecorator: WWStatusDecorator?
}

open class WWSelectedHeaderView: WWHeaderFooterView {
    public func expand() {
        self.reference.expand(section: self.section)
    }
}


