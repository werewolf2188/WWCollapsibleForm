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

/// View form to display sections where the user can choose between different options
/// This class can be used by setting the base view of a view controller inside the
/// storyboard or nib, or by adding it inside another view.
///
/// - Remark: It's truly recommended to use it with the size of the main screen.
public class WWCollapsibleForm : UIView {
    
    internal var privateForm : WWCollapsibleFormAdapter!
    internal var tableView : UITableView!
    internal var sections : [WWSection] = []
    internal var footerContainer: WWCollapsibleFormFooter!
    internal var _footer : UIView?
    internal let cellString : String = "cell"
    internal let itemTag : Int = 1000
    
    /// Delegate that will allow to modify headers and items and retrieve the selected item of a section.
    public var formDelegate : WWCollapsibleFormDelegate?
    /// Delegate that will catch the before and after of a collapse or the expand of a section.
    public var collapseDelegate: WWCollapsibleFormCollapseDelegate?
    /// An object that saves the basic configuration of the collapsible view.
    public var configuration : WWCollapsibleFormConfiguration = WWCollapsibleFormConfiguration()
    /// Retrieves the footer assigned by the function `setFooter`. The function can throw an exception
    /// if the height of the footer is 0.
    public var footer : UIView? {
        get {
            return _footer
        }
    }
    
    private func initialize() {
        self.tableView = UITableView(frame: self.bounds, style: .grouped)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellString)
        self.tableView.backgroundColor = self.configuration.containerBackgroundColor
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
        super.didMoveToSuperview()
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
    
    
    /// Sets a new footer to the form to be used after all the sections have collapsed and all options have been selected.
    /// - Parameter newFooter: The new footer to be set.
    /// - Throws: An error if the height of the view is 0.
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
    
    /// Adds a new section to the form. This functions has to be called during the loading of the view controller or before the form its added to container.
    /// - Parameter section: The new section to be added.
    public func append(section: WWSection) {
        if self.sections.count == 0 {
            section.status = .enabled
        }
        section.section = self.sections.count
        self.sections.append(section)
    }
}
