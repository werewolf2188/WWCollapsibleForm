//
//  WWCollapsibleForm.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 9/12/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
import UIKit

public class WWCollapsibleForm : UIView {
    
    var sections : [WWSection] = []
    let cellString : String = "cell"
    let minimumFooterHeight : CGFloat = 20
    let itemTag : Int = 1000
    
    var tableView : UITableView!
    
    public var formDelegate : WWCollapsibleFormDelegate?
    public var collapseDelegate: WWCollapsibleFormCollapseDelegate?
    
    private func initialize() {
        self.tableView = UITableView(frame: self.bounds, style: .grouped)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellString)
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
        self.tableView.separatorStyle = .none
        self.tableView.dataSource = self
        self.tableView.delegate = self
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


