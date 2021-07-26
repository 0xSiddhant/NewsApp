//
//  EverythingViewController.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 17/07/21.
//

import UIKit
import SafariServices

final class EverythingViewController: UITableViewController {
    
    lazy var seachController: UISearchController = {
        let sc = UISearchController()
        sc.searchBar.delegate = self
        return sc
    }()
    lazy var viewModel: EverythingViewModel = {
        return EverythingViewModel()
    }()
    private var dataSource: UITableViewDiffableDataSource<Int, Article>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = seachController
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Explore News"
        
        tableView.register(NewsFeedView.self, forCellReuseIdentifier: NewsFeedView.IDENTIFIER)
        tableView.separatorStyle = .none
        
        initializeViewModel()
        createDataSource()
    }
    
    //MARK:- Configuration Methods
    func initializeViewModel() {
        viewModel.reloadTableCallBack = { [unowned self] in
            self.seachController.dismiss(animated: true, completion: nil)
            self.populateData()
        }
    }
    func createDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Article>(tableView: tableView) { tv, indexPath, article in
            guard let cell = tv.dequeueReusableCell(withIdentifier: NewsFeedView.IDENTIFIER, for: indexPath) as? NewsFeedView else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.populateCell(article: article)
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
    }
}
