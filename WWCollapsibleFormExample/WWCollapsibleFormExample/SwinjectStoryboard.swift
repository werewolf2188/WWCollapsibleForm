//
//  SwiftInjectHolder.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/14/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import UIKit
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    @objc class func setup() {
        defaultContainer.register(IUnitOfWork.self) { _ in
            WWCollapsibleFormExampleContext()
            }.inObjectScope(.container)
        
        defaultContainer.register(MenuProvider.self, factory: { r in
            let interactor : MenuInteractor = MenuInteractor()
            interactor.context = r.resolve(IUnitOfWork.self)
            return interactor
        }).inObjectScope(.graph)
        
        defaultContainer.register(MenuViewEventHandler.self, factory: { r in
            let presenter : MenuPresenter = MenuPresenter()
            let provider : MenuProvider? = r.resolve(MenuProvider.self)
            provider?.output = presenter
            presenter.menuProvider = provider
            return presenter
        }).inObjectScope(.graph)
        
        defaultContainer.storyboardInitCompleted(ViewController.self) { r, c in
            let ev : MenuViewEventHandler? = r.resolve(MenuViewEventHandler.self)
            ev?.view = c
            c.eventHandler = ev
        }
        print("")
    }
}
