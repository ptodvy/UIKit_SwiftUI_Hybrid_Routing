//
//  AppDelegate.swift
//  SampleApp
//
//  Created by bruno on 7/22/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let router = NavigationRouter()
    
    class var main: AppDelegate {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError(#function)
        }
        return delegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootViewController = RootUIKitViewController()
        rootViewController.title = "UIKit Root"
        
        let mainViewController = CustomNavigationController(rootViewController: rootViewController)
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
        
        AppDelegate.main.router.navigationController = mainViewController
        
        return true
    }
}
