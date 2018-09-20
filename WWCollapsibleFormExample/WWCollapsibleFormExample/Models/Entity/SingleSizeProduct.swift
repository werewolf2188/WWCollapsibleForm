//
//  SingleSizeProduct.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/14/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import UIKit

class SingleSizeProduct: Product {
    var price : Double? = 0
    
    private enum CodingKeys: String, CodingKey {
        case price
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.price = try container.decodeIfPresent(Double.self, forKey: .price)
        try super.init(from: decoder)
    }
}
