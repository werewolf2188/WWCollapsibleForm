//
//  ViewController.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/12/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import UIKit
import WWCollapsibleForm
class ViewController: UIViewController {

    
    @IBOutlet weak var form : WWCollapsibleForm!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form.append(section: self.getCreditCartSections())
        form.append(section: self.getCreditCartSections())
        form.append(section: self.getCreditCartSections())
        form.append(section: self.getCreditCartSections())
        form.append(section: self.getCreditCartSections())
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getCreditCartSections() -> WWSection {
        
        let section : WWSection = WWSection(header: WWViewRepresentation(headerView: Header()),
                                            template: WWViewRepresentation(view: CellView()),
                                            selectedHeader: WWViewRepresentation(headerView: SelectedHeader()))
        
        section.appendData(data: WWTemplateDataObject())
        section.appendData(data: WWTemplateDataObject())
        return section
    }

}

