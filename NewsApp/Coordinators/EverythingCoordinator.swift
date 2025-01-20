//
//  EverythingCoordinator.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 20/01/25.
//

import UIKit
import SafariServices

final class EverythingCoordinator {
    
    private let navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()
    
    func makeViewController() -> UIViewController {
        let viewModel: EverythingViewModel = .init(safariCallBack: openNewsInSafari)
        navigationController.setViewControllers([
            EverythingViewController(viewModel: viewModel)
        ], animated: true)
        return navigationController
    }
    
    func openNewsInSafari(for url: URL) {
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = true
        config.entersReaderIfAvailable = true
        
        navigationController.present(
            SFSafariViewController(url: url,
                                   configuration: config),
            animated: true,
            completion: nil)
    }
}
