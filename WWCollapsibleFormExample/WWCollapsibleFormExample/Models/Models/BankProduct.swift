//
//  BankProduct.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/14/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import UIKit

enum ProductType : String, CodingKey {
    case none = "NONE"
    case account = "ACCOUNT"
    case creditCard = "CREDITCARD"
}

class BankProduct: Product {
    var balance : Float = 0
    var type : ProductType = .none
    
    private enum CodingKeys: String, CodingKey {
        case balance
        case type
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.balance = try container.decode(Float.self, forKey: .balance)
        self.type = try ProductType(stringValue: container.decode(String.self, forKey: .type)) ?? .none
        try super.init(from: decoder)
    }
}
