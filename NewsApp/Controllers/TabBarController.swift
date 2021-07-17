//
//  TabBarController.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 17/07/21.
//

import UIKit

final class TabBarController: UITabBarController {

    let firstController = UINavigationController(rootViewController: EverythingViewController())
    let secondController = UINavigationController(rootViewController: TopHeadingController())
    let thirdController = UINavigationController(rootViewController: SourceViewController())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [firstController, secondController, thirdController]
        selectedViewController = secondController
        selectedIndex = 1
        tabBar.isTranslucent = true
        
        setUpTabBarItem()
    }
    
    private func setUpTabBarItem() {
        let item = UITabBarItem()
        item.title = "Home"
        item.image = UIImage(systemName: "newspaper")
        firstController.tabBarItem = item
        
        let item1 = UITabBarItem()
        item1.title = "Heading"
        item1.image = UIImage(systemName: "rectangle.3.offgrid.bubble.left")
        secondController.tabBarItem = item1
        
        let item2 = UITabBarItem()
        item2.title = "Source"
        item2.image = UIImage(systemName: "bookmark")
        thirdController.tabBarItem = item2
     
    }
}
