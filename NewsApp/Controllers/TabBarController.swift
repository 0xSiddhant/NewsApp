//
//  TabBarController.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 17/07/21.
//

import UIKit

final class TabBarController: UITabBarController {

    var firstController: UIViewController
    var secondController: UIViewController
    var thirdController: UIViewController
    
    init(_ firstController: UIViewController, _ secondController: UIViewController, _ thirdController: UIViewController) {
        self.firstController = firstController
        self.secondController = secondController
        self.thirdController = thirdController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
