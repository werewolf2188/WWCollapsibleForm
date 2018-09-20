//
//  User.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/14/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import UIKit

class User: Codable {
    var name : String! = ""
    var accounts : [BankProduct] = []
    
    private enum CodingKeys: String, CodingKey {
        case name, accounts
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        var nestedContainer = try container.nestedUnkeyedContainer(forKey: .accounts)
        accounts.removeAll()
        while (!nestedContainer.isAtEnd) {
            let account = try nestedContainer.decode(BankProduct.self)
            accounts.append(account)
        }
    }
}
