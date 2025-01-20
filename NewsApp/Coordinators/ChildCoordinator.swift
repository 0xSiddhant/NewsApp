//
//  ChildCoordinator.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 20/01/25.
//

import UIKit

final class ChildCoordinator {
    private weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func makeViewController() -> UIViewController {
        UIViewController()
    }
}
