//
//  SelectedCreditCardHeader.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/12/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import UIKit
import WWCollapsibleForm
class SelectedHeader: WWSelectedHeaderView, MenuSelectedHeaderView {
    func set(productName: String) {
        self.productName.text = productName
    }
    
    func setImage(image: String?) {
        if image == nil || image?.isEmpty == true {
            self.imageView.isHidden = true
        }
        else if let image = image {
            self.imageView.image = UIImage(named: image)
        }
    }
    
    func set(money: String) {
        self.moneyLabel.text = money
    }
    
    func set(title: String) {
        self.titleLabel.text = title
    }
    
    func setSubtitle(title: String?) {
        if let titletext = self.titleLabel.text, let subTitle = title {
            self.titleLabel.text = "\(titletext): \(subTitle)"
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var modifyButton: UIButton!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func OnModify(_ sender: Any) {
        self.expand()
    }
}
