//
//  ViewController.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/12/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import UIKit
import WWCollapsibleForm
class ViewController: UIViewController, MenuView {
    
    var eventHandler: MenuViewEventHandler?
    @IBOutlet weak var form : WWCollapsibleForm!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventHandler?.loadSections()
        self.form.formDelegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getSections(sections: [WWSection]) {
        sections.forEach { (section) in
            form.append(section: section)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController : WWCollapsibleFormDelegate {
    func modifyHeader(header: UIView, section: Int) {
        if let header = header as? MenuHeaderView {
            self.eventHandler?.loadHeader(header: header, section: section)
        }
    }
    
    func modifyItem(item: UIView, data: WWDataObject, section: Int) {
        if let item = item as? MenuItemView {
            self.eventHandler?.loadItem(item: item, section: section, data: data)
        }
    }
    
    func itemSelected(data: WWDataObject, section: Int) {
        self.eventHandler?.itemSelected(section: section, data: data)
    }
}

