//
//  ViewController.swift
//  WeatherApp
//
//  Created by Siddhant Kumar on 14/07/21.
//

import UIKit
import SafariServices

class TopHeadingController: UITableViewController {
    
    lazy var viewModel: TopHeadingViewModel = {
        let vm = TopHeadingViewModel()
        return vm
    }()
    
    lazy var rc: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.attributedTitle = NSAttributedString(string: "Refresh")
        rc.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        return rc
    }()
    
    deinit {
        debugPrint(#file)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Top Heading"
        
        tableView.separatorStyle = .none
        tableView.register(NewsFeedView.self, forCellReuseIdentifier: NewsFeedView.IDENTIFIER)
        tableView.refreshControl = rc
        
        initvm()
        viewModel.fetchData()
    }
    
    private func initvm() {
        viewModel.reloadTableCallBack = { [unowned self ] in
            self.rc.endRefreshing()
            self.tableView.reloadData()
        }
    }
    
    //MARK: OBJC Methods
    @objc
    func refreshTableView() {
        viewModel.fetchData()
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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = viewModel.getSelectedNewsLink(of: indexPath) else { return }
        
        let config = SFSafariViewController.Configuration()
        config.barCollapsingEnabled = true
        config.entersReaderIfAvailable = true
        
        present(SFSafariViewController(url: url,
                                       configuration: config),
                animated: true,
                completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
