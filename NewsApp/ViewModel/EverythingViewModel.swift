//
//  EverythingViewController.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 26/07/21.
//

import UIKit

class EverythingViewModel {
    
    //MARK:- Properties
    var sortType: Box<SortByList> = Box(.publishedAt)
    private var pageNo = 1
    private var isAPICalled = false
    var reloadTableCallBack: (() -> Void)?
    var searchTerm: String! {
        didSet {
            fetchData()
        }
    }
    var source: String?
    private var model: ArticleModal! {
        didSet {
            reloadTableCallBack?()
        }
    }
    var getArticleList: [Article] {
        if model == nil { return [] }
        return model.articles
    }
    
    weak var controller: UIViewController?
    init(controller: UIViewController) {
        self.controller = controller
    }
    
    func clearData() {
        model = nil
    }
    func canApplyPagination(_ index: Int) {
        if index == model.articles.count - 1 &&
            model.articles.count < model.totalResults &&
            !isAPICalled {
            pageNo += 1
            fetchData()
        }
    }
    
    func fetchData() {
        var params = [String: Any]()
        params["q"] = searchTerm
        params["sortBy"] = sortType.value.rawValue
        if !UserDefaultsData.language.isEmpty {
            params["language"] = UserDefaultsData.language
        }
        params["pageSize"] = 20
        params["page"] = pageNo
        if let src = source {
            params["sources"] = src
        }
        
        isAPICalled = true
        NetworkManager.sharedInstance.fetchData(endPoint: .everything,
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
