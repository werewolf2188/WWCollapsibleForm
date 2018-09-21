//
//  WWCollapsibleForm.swift
//  WWCollapsibleForm
//
//  Created by Enrique Ricalde on 9/12/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
import UIKit

public class WWCollapsibleForm : UITableView {
    
    var sections : [WWSection] = []
    let cellString : String = "cell"
    let minimumFooterHeight : CGFloat = 20
    let itemTag : Int = 1000
    
    public var formDelegate : WWCollapsibleFormDelegate?
    
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
        section.section = self.sections.count
        self.sections.append(section)
    }
}


