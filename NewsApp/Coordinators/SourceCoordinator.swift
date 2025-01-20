//
//  SourceCoordinator.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 20/01/25.
//

import UIKit
import SafariServices

final class SourceCoordinator {
    
    private let navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()
    
    func makeViewController() -> UIViewController {
        let viewModel: SourceViewModel = .init(openNewsHomePage)
        navigationController.setViewControllers([
            SourceViewController(viewModel: viewModel)
        ], animated: true)
        return navigationController
    }
    
    private func openNewsHomePage(of url: URL) {
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = true
        config.entersReaderIfAvailable = false
        
        navigationController.present(
            SFSafariViewController(url: url,
                                   configuration: config),
            animated: true
        )
    }
}
