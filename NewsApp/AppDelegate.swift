//
//  AppDelegate.swift
//  WeatherApp
//
//  Created by Siddhant Kumar on 14/07/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabBarController()
//        window?.rootViewController = UINavigationController(rootViewController: ViewController())
        window?.makeKeyAndVisible()
        
        UIImageView.appearance().tintColor = .systemGreen
        UIBarButtonItem.appearance().tintColor = .systemGreen
        UITabBar.appearance().tintColor = .systemGreen
        UIButton.appearance().tintColor = .systemGreen
        
        return true
    }
    
}

