//
//  SingleSizeProduct.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/14/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import UIKit

class SingleSizeProduct: Product {
    let price : Float! 
    
    private enum CodingKeys: String, CodingKey {
        case price
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.price = try container.decode(Float.self, forKey: .price)
        try super.init(from: decoder)
    }
}
