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

