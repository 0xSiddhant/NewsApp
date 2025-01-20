//
//  EverythingViewModel.swift
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
            Task {
                await fetchData()
            }
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
    var safariCallBack: ((URL) -> Void)
    
    init(safariCallBack: @escaping (URL) -> Void) {
        self.safariCallBack = safariCallBack
    }
    
    func clearData() {
        model = nil
    }
    func canApplyPagination(_ index: Int) {
        if index == model.articles.count - 1 &&
            model.articles.count < model.totalResults &&
            !isAPICalled {
            pageNo += 1
            Task {
                await fetchData()
            }
        }
    }
    
    func fetchData() async {
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
        do {
            let data = try await NetworkManager.sharedInstance.fetchData(endPoint: .everything,
                                                                         params: params,
                                                                         method: .GET,
                                                                         responseType: ArticleModal.self
            )
            await MainActor.run {
                if self.pageNo == 1 {
                    self.model = data
                } else {
                    self.model.articles +=  data.articles
                }
                isAPICalled = false
            }
        } catch let error {
            debugPrint((error as! NewsAPIError).showErrorMessage)
        }
    }
    
    func openNews(of urlString: String?) {
        guard let urlString = urlString,
              let url = URL(string: urlString) else { return }
        safariCallBack(url)
    }
}
