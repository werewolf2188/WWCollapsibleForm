//
//  AlternateCell.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique on 9/23/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import UIKit
import WWCollapsibleForm
class AlternateCell: WWItemView {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertLabel: UILabel!
    
    override func awakeFromNib() {
        self.disableDecorator = WWStatusDecorator(decoratorFunction: { (_) in
            self.backgroundColor = UIColor.lightGray
            self.alertView.backgroundColor = UIColor.darkGray
            self.alertLabel.textColor = UIColor.lightGray
        })
        self.enableDecorator = WWStatusDecorator(decoratorFunction: { (_) in
            self.backgroundColor = UIColor.white
            self.alertView.backgroundColor = UIColor(red: 245.0/255.0, green: 127.0/255.0, blue: 24.0/255.0, alpha: 1)
            self.alertLabel.textColor = UIColor.white
            self.isUserInteractionEnabled = true
        })
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
