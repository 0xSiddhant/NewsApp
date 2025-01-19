//
//  EverythingViewController.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 17/07/21.
//

import UIKit
import SafariServices

final class EverythingViewController: UITableViewController {
    //MARK: - Properties
    lazy var seachController: UISearchController = {
        let sc = UISearchController()
        sc.searchBar.delegate = self
        return sc
    }()
    lazy var viewModel: EverythingViewModel = {
        return EverythingViewModel(controller: self)
    }()
    lazy var voiceSearchBarBtn: UIBarButtonItem = {
        let btn = UIBarButtonItem()
        btn.image = UIImage(systemName: "mic.circle.fill")
        btn.target = self
        btn.action = #selector(voiceSearchBtnAction)
        return btn
    }()
    private var dataSource: UITableViewDiffableDataSource<Int, Article>!
    var sourceID: String?
    var sourceName: String?
    
    //MARK: - View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = seachController
        navigationController?.navigationBar.prefersLargeTitles = true
        
        if #available(iOS 14.0, *) {
            navigationItem.rightBarButtonItems = [.init(systemItem: .action), voiceSearchBarBtn]
            navigationItem.rightBarButtonItems!.first!.menu = UIMenu(
                title: "Sort By",
                options: .destructive,
                children: fetchCategoriesList())
        } else {
            navigationItem.rightBarButtonItem = voiceSearchBarBtn
        }
        
        tableView.register(NewsFeedView.self, forCellReuseIdentifier: NewsFeedView.IDENTIFIER)
        tableView.separatorStyle = .none
        
        initializeViewModel()
        createDataSource()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.source = sourceID
        if sourceID != nil {
            viewModel.clearData()
            seachController.searchBar.becomeFirstResponder()
            navigationItem.title = sourceName ?? ""
        } else {
            navigationItem.title = "Explore News"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewModel.source = nil
        sourceID = nil
    }
    
    @objc
    func voiceSearchBtnAction() {
        SpeechRecognizer.shared.processAudio { [weak self] lastString in
            self?.seachController.searchBar.text = lastString
        }
    }
    
    //MARK: - Configuration Methods
    func initializeViewModel() {
        viewModel.reloadTableCallBack = { [unowned self] in
            self.seachController.dismiss(animated: true, completion: nil)
            self.populateData()
        }
        viewModel.sortType.bind { [unowned self] _ in
            if let query = self.viewModel.searchTerm,
               !query.isEmpty {
                Task {
                    await self.viewModel.fetchData()
                }
            }
        }
    }
    
    //MARK: Populate TableView
    func createDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Article>(tableView: tableView) { tv, indexPath, article in
            guard let cell = tv.dequeueReusableCell(withIdentifier: NewsFeedView.IDENTIFIER, for: indexPath) as? NewsFeedView else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.populateCell(article: article)
            self.viewModel.canApplyPagination(indexPath.row)
            return cell
        }
        tableView.dataSource = dataSource
    }
    
    func populateData() {
        guard let dataSource = dataSource else {
            return
        }
        var snapshot = dataSource.snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections([0])
        snapshot.appendItems(viewModel.getArticleList, toSection: 0)
        dataSource.apply(snapshot,
                         animatingDifferences: true,
                         completion: nil)
    }
    
    private func fetchCategoriesList() -> [UIMenuElement] {
        var elements = [UIMenuElement]()
        
        for sortItem in SortByList.allCases {
            let item = UIAction(title: sortItem.title
            ) { [weak self] alert in
                self?.viewModel.sortType.value = sortItem
            }
            elements.append(item)
        }
        return elements
    }
    
    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let snapshot = dataSource.snapshot()
        
        guard let urlString = snapshot.itemIdentifiers[indexPath.row].url,
              let url = URL(string: urlString) else { return }
        
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = true
        config.entersReaderIfAvailable = true
        
        present(SFSafariViewController(url: url,
                                       configuration: config),
                animated: true,
                completion: nil)
    }
}


extension EverythingViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.searchTerm = searchBar.text ?? ""
        SpeechRecognizer.shared.cancelRecording()
    }
}
