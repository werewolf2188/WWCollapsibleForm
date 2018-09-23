//
//  CreditCardHeader.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/12/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import UIKit
import WWCollapsibleForm

class Header: WWHeaderView, MenuHeaderView {
    func set(title: String) {
        self.titleLabel.text = title
    }
    
    func setSubtitle(title: String?) {
        if let titletext = self.titleLabel.text, let subTitle = title {
            self.titleLabel.text = "\(titletext): \(subTitle)"
        }
    }
    

    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        self.disableDecorator = WWStatusDecorator(decoratorFunction: { (_) in
            self.backgroundColor = UIColor.lightGray
            self.titleLabel.textColor = UIColor.darkGray
        })
        
        self.enableDecorator = WWStatusDecorator(decoratorFunction: { (_) in
            self.backgroundColor = UIColor.white
            self.titleLabel.textColor = UIColor.black
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
