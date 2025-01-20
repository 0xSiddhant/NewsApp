//
//  TopHeadingCoordinator.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 19/01/25.
//

import UIKit
import SafariServices

final class TopHeadingCoordinator {
    
    private let navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }()
    
    func makeViewController() -> UIViewController {
        let viewModel = TopHeadingViewModel(
            openSettingCallBack: presentSettingPage,
            openSafariPage: openSafariPage
        )
        navigationController.setViewControllers([TopHeadingController(viewModel: viewModel)], animated: true)
        return navigationController
    }
    
    private func presentSettingPage(_ vc: SettingPageController) {
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .flipHorizontal
        navigationController.present(vc,
                                     animated: true,
                                     completion: nil)
    }
    
    private func openSafariPage(with url: URL) {
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = true
        config.entersReaderIfAvailable = true
        
        navigationController.present(
            SFSafariViewController(url: url,
                                   configuration: config),
            animated: true,
            completion: nil)
    }
    
    private func openChildController() {
        let coordinator = ChildCoordinator(navigationController: navigationController)
        navigationController.pushViewController(coordinator.makeViewController(), animated: true)
    }
}
