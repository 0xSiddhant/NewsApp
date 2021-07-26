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
    lazy var viewModel: SourceViewModel = {
        return SourceViewModel()
    }()
    private var dataSource: UITableViewDiffableDataSource<Int, Source>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Sources"
        
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 20
        tableView.register(SourceItemView.self, forCellReuseIdentifier: SourceItemView.IDENTIFIER)
        
        createDataSource()
        initializeViewModel()
        viewModel.fetchAPI()
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
        
        viewModel.openBrowserCallBack = { [unowned self] in
            let config = SFSafariViewController.Configuration()
            config.barCollapsingEnabled = true
            config.entersReaderIfAvailable = false
            
            present(SFSafariViewController(url: $0,
                                           configuration: config),
                    animated: true,
                    completion: nil)
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
    
    //MARK:- TableView Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedIndex(indexPath.row)
    }
}
