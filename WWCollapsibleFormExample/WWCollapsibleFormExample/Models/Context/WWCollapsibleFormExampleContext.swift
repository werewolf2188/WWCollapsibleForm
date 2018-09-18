//
//  WWCollapsibleFormExampleContext.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/14/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import UIKit

class WWCollapsibleFormExampleContext: NSObject, IUnitOfWork {
    var database : Database!
    
    private func load() {
        let decoder : JSONDecoder = JSONDecoder()
        do {
            if let path : String = Bundle.main.path(forResource: "mcdonalds_menu", ofType: "json") {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                database = try decoder.decode(Database.self, from: data)
                print("done")
            }            
        }
        catch {
        }
    }
    
    override init() {
        super.init()
        self.load()
    }
}
