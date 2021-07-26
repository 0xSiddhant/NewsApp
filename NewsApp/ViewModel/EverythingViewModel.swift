//
//  EverythingViewController.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 26/07/21.
//

import Foundation

class EverythingViewModel {
    
    //MARK:- Properties
    var reloadTableCallBack: (() -> Void)?
    var searchTerm: String! {
        didSet {
            fetchData()
        }
    }
    private var model: ArticleModal! {
        didSet {
            reloadTableCallBack?()
        }
    }
    var getArticleList: [Article] {
        return model.articles
    }
    
    func fetchData() {
        var params = [String: Any]()
        params["q"] = searchTerm
        NetworkManager.sharedInstance.fetchData(endPoint: .everything,
                                                params: params,
                                                method: .GET,
                                                responseType: ArticleModal.self
        ) { response in
            switch response {
            case .success(let data):
                self.model = data
            case .failure(let error):
                debugPrint(error.showErrorMessage)
            }
        }
    }
}
