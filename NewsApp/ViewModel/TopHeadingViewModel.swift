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
    private var pageNo: Int
    private var isAPICalled: Bool
    private var model: ArticleModal! {
        didSet {
            reloadTableCallBack?()
        }
    }
    var categoryType: Box<Categories?>
    
    private var openSettingCallBack: (SettingPageController) -> Void
    private var openSafariPage: ((URL) -> Void)
    
    init(
        openSettingCallBack: @escaping (SettingPageController) -> Void,
        openSafariPage: @escaping ((URL) -> Void)
    ) {
        self.pageNo = 1
        self.isAPICalled = false
        self.categoryType = Box(nil)
        self.openSettingCallBack = openSettingCallBack
        self.openSafariPage = openSafariPage
    }
    
    var noOfRows: Int {
        if model == nil { return 0}
        return model.articles.count
    }
    
    deinit {
        debugPrint(#file)
    }
    
    func getData(at indexPath: IndexPath) -> Article {
        return model.articles[indexPath.row]
    }
    
    func openSelectedNewsLink(of indexPath: IndexPath) {
        guard let urlString =  model.articles[indexPath.row].url,
              let url = URL(string: urlString) else {
            return
        }
        openSafariPage(url)
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
    //MARK:- API Calls
    func fetchData() async {
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
        
        do {
            await NetworkManager.sharedInstance.toggleLoaderView(true)
            let response = try await NetworkManager.sharedInstance.fetchData(endPoint: .headlines,
                                                                             params: params,
                                                                             method: .GET,
                                                                             responseType: ArticleModal.self
            )
            await MainActor.run {
                NetworkManager.sharedInstance.toggleLoaderView(false)
                if self.pageNo == 1 {
                    self.model = response
                } else {
                    self.model.articles +=  response.articles
                }
                self.isAPICalled = false
            }
        } catch let error {
            debugPrint(error)
        }
        
    }
    
    func openSettingPage() {
        let vc = SettingPageController()
        vc.selectionCallBack = {
            UserDefaultsData.isSourceUpdateNeeded = true
            Task {
                await self.fetchData()
            }
        }
        openSettingCallBack(vc)
    }
}
