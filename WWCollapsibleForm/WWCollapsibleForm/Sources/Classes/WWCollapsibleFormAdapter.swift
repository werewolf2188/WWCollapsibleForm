//
//  WWCollapsibleFormPrivate.swift
//  WWCollapsibleForm
//
//  Created by Enrique on 9/23/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
class WWCollapsibleFormAdapter : NSObject {
    
    var publicForm : WWCollapsibleForm!
    
    override init() {
        super.init()
    }
    convenience init(form: WWCollapsibleForm) {
        self.init()
        self.publicForm = form
    }
    
    var tableView : UITableView! {
        get {
            return self.publicForm.tableView
        }
    }
    var sections : [WWSection] {
        get {
            return self.publicForm.sections
        }
    }
    var cellString : String {
        get {
            return self.publicForm.cellString
        }
    }
    var minimumFooterHeight : CGFloat {
        get {
            return self.publicForm.minimumFooterHeight
        }
    }
    var itemTag : Int {
        get {
            return self.publicForm.itemTag
        }
    }
    
    var formDelegate : WWCollapsibleFormDelegate? {
        get {
            return self.publicForm.formDelegate
        }
    }
}
