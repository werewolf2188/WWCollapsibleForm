
//
//  MultipleSizeProduct.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/14/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import UIKit

class MultipleSizeProduct: Product {
    let children: [ProductSize]!
    
    private enum CodingKeys: String, CodingKey {
        case children
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)        
        var nestedContainer = try container.nestedUnkeyedContainer(forKey: .children)
        children = []
        while (!nestedContainer.isAtEnd) {
            let size = try nestedContainer.decode(ProductSize.self)
            children.append(size)
        }
        
        try super.init(from: decoder)
    }
}
