//
//  ViewController.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 17/07/21.
//

import UIKit
import SafariServices

final class SourceViewController: UITableViewController {
    
    //MARK:- Properties
    let viewModel: SourceViewModel
    private var dataSource: UITableViewDiffableDataSource<Int, Source>!
    
    init(viewModel: SourceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Sources"
        
        if #available(iOS 14.0, *) {
            navigationItem.rightBarButtonItem = .init(systemItem: .organize)
            navigationItem.rightBarButtonItem!.menu = UIMenu(
                title: "Categories",
                options: .displayInline,
                children: fetchCategoriesList())
        }
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 20
        tableView.register(SourceItemView.self, forCellReuseIdentifier: SourceItemView.IDENTIFIER)
        
        createDataSource()
        initializeViewModel()
        UserDefaultsData.isSourceUpdateNeeded = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if UserDefaultsData.isSourceUpdateNeeded {
            Task {
                await viewModel.fetchAPI()
            }
            UserDefaultsData.isSourceUpdateNeeded = false
        }
    }
    
    //MARK:- Configuration Methods
    func initializeViewModel() {
        viewModel.reloadTableViewCallBack = { [unowned self] in
            self.populateData()
        }
        
        viewModel.reloadCellsCallBack = { [unowned self] in
            var snapShot = dataSource.snapshot()
            snapShot.reloadItems($0)
            dataSource.apply(snapShot,
                             animatingDifferences: true)
        }
        
        viewModel.categoryType.bind { [unowned self] cat in
            if cat != nil {
                Task {
                    await self.viewModel.fetchAPI()
                }
            }
        }
        
        viewModel.sourceIDCallBack = { [unowned self] in
            guard let vc = self.tabBarController?.viewControllers?.first?.children.first as? EverythingViewController else { return }
            vc.sourceID = $0
            vc.sourceName = $1
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    func createDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Source>(tableView: tableView) { [unowned self] tv, indexPath, source in
            guard let cell = tv.dequeueReusableCell(withIdentifier: SourceItemView.IDENTIFIER, for: indexPath) as? SourceItemView else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.tag = indexPath.row
            cell.viewModel = viewModel
            cell.setUpStackView(addStackView: indexPath.row == self.viewModel.previousSelectedIndex)
            cell.populateData(source: source)
            return cell
        }
        tableView.dataSource = dataSource
    }
    
    func populateData() {
        guard let dataSource = dataSource else {
            return
        }
        var snapshot = NSDiffableDataSourceSnapshot<Int, Source>()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.getSourceList, toSection: 0)
        dataSource.apply(snapshot,
                         animatingDifferences: true,
                         completion: nil)
    }
    
    private func fetchCategoriesList() -> [UIMenuElement] {
        var elements = [UIMenuElement]()
        
        for category in Categories.allCases {
            let item = UIAction(title: category.title,
                                image: UIImage(systemName: category.imageName)
            ) { [weak self] alert in
                self?.viewModel.categoryType.value = category
            }
            elements.append(item)
        }
        let noneCase = UIAction(
            title: "All",
            image: UIImage(systemName: "pencil.and.outline")
        ) { [weak self] _ in
            self?.viewModel.categoryType.value = nil
            Task {
                await self?.viewModel.fetchAPI()
            }
        }
        elements.append(noneCase)
        return elements
    }
    
    //MARK:- TableView Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedIndex(indexPath.row)
    }
}
