//
//  ViewController.swift
//  WeatherApp
//
//  Created by Siddhant Kumar on 14/07/21.
//

import UIKit
import SafariServices

class TopHeadingController: UITableViewController {
    
    let viewModel: TopHeadingViewModel
    
    lazy var rc: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.attributedTitle = NSAttributedString(string: "Refresh")
        rc.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        return rc
    }()
    
    lazy var settingBarBtn: UIBarButtonItem = {
        let barBtn = UIBarButtonItem( image: UIImage(systemName: "filemenu.and.selection"),
                                      style: .plain,
                                      target: self,
                                      action: #selector(showSettingPage))
        barBtn.tintColor = .systemGreen
        return barBtn
    }()
    
    init(viewModel: TopHeadingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        debugPrint(#file)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Top Heading"
        navigationItem.leftBarButtonItem = settingBarBtn
        
        if #available(iOS 14.0, *) {
            navigationItem.rightBarButtonItem = .init(systemItem: .organize)
            navigationItem.rightBarButtonItem!.menu = UIMenu(
                title: "Categories",
                options: .displayInline,
                children: fetchCategoriesList())
        }
        
        tableView.separatorStyle = .none
        tableView.register(NewsFeedView.self, forCellReuseIdentifier: NewsFeedView.IDENTIFIER)
        tableView.refreshControl = rc
        
        initvm()
        Task {
            await viewModel.fetchData()            
        }
    }
    
    private func initvm() {
        viewModel.reloadTableCallBack = { [unowned self ] in
            self.rc.endRefreshing()
            self.tableView.reloadData()
        }
        
        viewModel.categoryType.bind { [unowned self] cat in
            if cat != nil {
                Task {
                    await self.viewModel.fetchData()
                }
            }
        }
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
                await self?.viewModel.fetchData()
            }
        }
        elements.append(noneCase)
        return elements
    }
    
    //MARK:- OBJC Methods
    @objc
    func refreshTableView() {
        Task {
            await viewModel.fetchData()
        }
    }
    
    @objc
    func showSettingPage() {
        viewModel.openSettingPage()
    }
}

//MARK:- TableView Methods
extension TopHeadingController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.noOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsFeedView.IDENTIFIER, for: indexPath) as? NewsFeedView else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.populateCell(article: viewModel.getData(at: indexPath))
        viewModel.canApplyPagination(indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.openSelectedNewsLink(of: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
