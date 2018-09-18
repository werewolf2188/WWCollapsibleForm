//
//  Menu.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/14/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import UIKit

class Menu: Codable {
    var combos : [SingleSizeProduct]! = []
    var sides : [MultipleSizeProduct]! = []
    var desserts : [SingleSizeProduct]! = []
    
    private enum CodingKeys: String, CodingKey {
        case combos, sides, desserts
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var nestedContainer = try container.nestedUnkeyedContainer(forKey: .combos)
        combos.removeAll()
        while (!nestedContainer.isAtEnd) {
            let combo = try nestedContainer.decode(SingleSizeProduct.self)
            combos.append(combo)
        }
        
        nestedContainer = try container.nestedUnkeyedContainer(forKey: .sides)
        sides.removeAll()
        while (!nestedContainer.isAtEnd) {
            let side = try nestedContainer.decode(MultipleSizeProduct.self)
            sides.append(side)
        }
        
        nestedContainer = try container.nestedUnkeyedContainer(forKey: .desserts)
        desserts.removeAll()
        while (!nestedContainer.isAtEnd) {
            let dessert = try nestedContainer.decode(SingleSizeProduct.self)
            desserts.append(dessert)
        }
        
    }
}
