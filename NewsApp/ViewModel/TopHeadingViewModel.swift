//
//  TopHeadingViewModel.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 20/07/21.
//

import UIKit

class TopHeadingViewModel {
    
    //MARK:- Properties
    var reloadTableCallBack: (() -> Void)?
    private let pageSize = 40
    private var pageNo = 1
    private var isAPICalled = false
    private var model: ArticleModal! {
        didSet {
            reloadTableCallBack?()
        }
    }
    var categoryType: Box<Categories?> = Box(nil)
    
    var noOfRows: Int {
        if model == nil { return 0}
        return model.articles.count
    }
    
    weak var controller: UIViewController?
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    deinit {
        debugPrint(#file)
    }
    
    func getData(at indexPath: IndexPath) -> Article {
        return model.articles[indexPath.row]
    }
    
    func getSelectedNewsLink(of indexPath: IndexPath) -> URL? {
        if let urlString =  model.articles[indexPath.row].url {
            return URL(string: urlString)
        }
        return nil
    }
    
    func canApplyPagination(_ index: Int) {
        if index == model.articles.count - 1 &&
            model.articles.count < model.totalResults &&
            !isAPICalled {
            pageNo += 1
            fetchData()
        }
    }
    //MARK:- API Calls
    func fetchData() {
        var params = [String: Any]()
        if !UserDefaultsData.country.isEmpty {
            params["country"] = UserDefaultsData.country
        } else {
            params["country"] = "in"
        }
        if let category = categoryType.value {
            params["category"] = category.rawValue
        }
        params["pageSize"] = pageSize
        params["page"] = pageNo
        isAPICalled = true
        NetworkManager.sharedInstance.fetchData(endPoint: .headlines,
                                                params: params,
                                                method: .GET,
                                                responseType: ArticleModal.self,
                                                controller: controller
        ) { response in
            switch response {
            case .success(let data):
                if self.pageNo == 1 {
                    self.model = data
                } else {
                    self.model.articles +=  data.articles
                }
                self.isAPICalled = false
            case .failure(let error):
                debugPrint(error.showErrorMessage)
            }
        }
    }
}
