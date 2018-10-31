//
//  Footer.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique on 10/30/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import UIKit

class Footer: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    static func getFooter() -> Footer {
        let view : Footer = Bundle(for: Footer.self).loadNibNamed(String(describing:Footer.self), owner: nil, options: nil)?.first as? Footer ?? Footer(frame: CGRect.zero)
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150)
        return view
    }
}
