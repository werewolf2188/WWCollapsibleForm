//
//  MenuView.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/20/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
import WWCollapsibleForm
protocol MenuView : NSObjectProtocol {
    func getSections(sections: [WWSection])
}
