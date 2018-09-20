//
//  MenuSection.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/20/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation
struct MenuSection {
    var title : String!
    var subtitle : String?
    var items : [MenuItem] = []
}

struct MenuItem {
    var id : String!
    var name : String!
    var image : String?
    var price : Float? 
    var children : [MenuItem]?
}
