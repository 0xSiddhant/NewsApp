//
//  RootCoordinator.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 19/01/25.
//

import UIKit

final class RootCoordinator {
    
    func makeInitialView() -> UIViewController {
        let tabBarController = TabBarController(
            EverythingCoordinator().makeViewController(),
            TopHeadingCoordinator().makeViewController(),
            SourceCoordinator().makeViewController()
        )
        return tabBarController
    }
}
