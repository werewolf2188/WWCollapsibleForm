//
//  WWCollapsibleForm.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 9/12/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
import UIKit

extension String: Error {}

public class WWCollapsibleForm : UIView {
    
    var tableView : UITableView!
    var sections : [WWSection] = []
    let cellString : String = "cell"
    let minimumFooterHeight : CGFloat = 20
    let itemTag : Int = 1000
    var privateForm : WWCollapsibleFormAdapter!

    public var formDelegate : WWCollapsibleFormDelegate?
    public var collapseDelegate: WWCollapsibleFormCollapseDelegate?
    
    internal var footerContainer: WWCollapsibleFormFooter!
    internal var _footer : UIView?
    public var footer : UIView? {
        get {
            return _footer
        }
    }
    
    public func setFooter(newFooter: UIView?) throws {
        if _footer != nil && _footer != newFooter {
            _footer?.removeFromSuperview()
            
        }
        if footerContainer != nil {
            footerContainer.removeFromSuperview()
            footerContainer = nil
        }
        if let frame = newFooter?.frame,
            frame.size.height == 0{
            throw "Height cannot be 0"
        }
        _footer = newFooter
        
        if let f = _footer {
            self.footerContainer = WWCollapsibleFormFooter(subView: f, superView: self)
        }
    }
    
    private func initialize() {
        self.tableView = UITableView(frame: self.bounds, style: .grouped)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellString)
        self.privateForm = WWCollapsibleFormAdapter(form: self)
        
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    public override func didMoveToSuperview() {
        self.tableView.frame = self.bounds
        self.addSubViewWithConstraints(self.tableView)
        if (self.footerContainer != nil) {
            self.bringSubview(toFront: self.footerContainer)
        }
        self.tableView.separatorStyle = .none
        self.tableView.dataSource = self.privateForm
        self.tableView.delegate = self.privateForm
        self.tableView.backgroundColor = self.backgroundColor
    }
    
    //Add new section
    public func append(section: WWSection) {
        if self.sections.count == 0 {
            section.status = .enabled
        }
        section.section = self.sections.count
        self.sections.append(section)
    }
}
