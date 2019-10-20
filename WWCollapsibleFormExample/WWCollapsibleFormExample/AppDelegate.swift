//
//  AppDelegate.swift
//  WWCollapsibleFormExample
//
//  Created by Enrique Ricalde on 9/12/18.
//  Copyright © 2018 werewolf. All rights reserved.
//

import UIKit
import Swinject
import WWCollapsibleForm

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let container: Container = {
        let defaultContainer = Container()
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
        
        defaultContainer.register(ViewController.self) { r in
            let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle(for: ViewController.self))
            let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
            let c = navigationController?.topViewController as! ViewController
            c.navigationItem.hidesBackButton = true
            let ev : MenuViewEventHandler? = r.resolve(MenuViewEventHandler.self)
            ev?.view = c
            c.eventHandler = ev
            return c
        }
        
        
        print("")
        return defaultContainer
        }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()
        self.window = window

        let storyboard = UIStoryboard.init(name: "Main", bundle: Bundle(for: ViewController.self))
        let navigationController = storyboard.instantiateInitialViewController() as? UINavigationController
        navigationController?.pushViewController(container.resolve(ViewController.self)!, animated: false)
        // Instantiate the root view controller with dependencies injected by the container.
        window.rootViewController = navigationController
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

