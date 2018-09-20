//
//  ProductSize.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/14/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import UIKit

class ProductSize: Codable {
    var id : String! = ""
    var name: String! = ""
    var price : Float = 0
    
    private enum CodingKeys: String, CodingKey {
        case id, name, price
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.price = try container.decode(Float.self, forKey: .price)
        
    }
}
