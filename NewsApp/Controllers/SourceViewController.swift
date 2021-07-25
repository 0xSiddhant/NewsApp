//
//  ViewController.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 17/07/21.
//

import UIKit

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
    }
    
    func createDataSource() {
        dataSource = UITableViewDiffableDataSource<Int, Source>(tableView: tableView) { [unowned self] tv, indexPath, source in
            guard let cell = tv.dequeueReusableCell(withIdentifier: SourceItemView.IDENTIFIER, for: indexPath) as? SourceItemView else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.title.textColor = indexPath.row == self.viewModel.previousSelectedIndex ? .systemRed : .systemTeal
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var snapShot = dataSource.snapshot()
        snapShot.reloadItems(viewModel.selectedIndex(indexPath.row))
        dataSource.apply(snapShot,
                         animatingDifferences: true)
    }
    
}
