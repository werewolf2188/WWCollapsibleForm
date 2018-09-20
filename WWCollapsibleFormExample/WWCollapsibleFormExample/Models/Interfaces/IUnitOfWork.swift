//
//  IUnitOfWork.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/14/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import Foundation

protocol IUnitOfWork : NSObjectProtocol {
    var database : Database! { get set }
}
