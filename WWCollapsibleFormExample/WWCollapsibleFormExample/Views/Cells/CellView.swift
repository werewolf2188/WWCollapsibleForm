//
//  CreditCard.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/12/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import UIKit
import WWCollapsibleForm
class CellView: WWItemView, MenuItemView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    
    func set(productName: String) {
        self.productName.text = productName
    }
    
    func setImage(image: String?) {
        if image == nil || image?.isEmpty == true{
            self.imageView.isHidden = true
        }
        // else more to come
    }
    
    func set(money: String) {
        self.moneyLabel.text = money
    }
    
    override func awakeFromNib() {
        self.disableDecorator = WWStatusDecorator(decoratorFunction: { (_) in
            self.backgroundColor = UIColor.lightGray
            self.productName.textColor = UIColor.darkGray
            self.moneyLabel.textColor = UIColor.darkGray
            self.imageView.backgroundColor = UIColor.darkGray
            self.isUserInteractionEnabled = false
        })
        self.enableDecorator = WWStatusDecorator(decoratorFunction: { (_) in
            self.backgroundColor = UIColor.white
            self.productName.textColor = UIColor.black
            self.moneyLabel.textColor = UIColor.black
            self.imageView.backgroundColor = UIColor.clear
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
