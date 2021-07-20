//
//  TopHeadingViewModel.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 20/07/21.
//

import Foundation

class TopHeadingViewModel {
    
    //MARK:- Properties
    var reloadTableCallBack: (() -> Void)?
    
    private var model: ArticleModal! {
        didSet {
            reloadTableCallBack?()
        }
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
    
    func getSelectedNewsLink(of indexPath: IndexPath) -> URL? {
        if let urlString =  model.articles[indexPath.row].url {
            return URL(string: urlString)
        }
        return nil
    }
    
    //MARK:- API Calls
    func fetchData() {
        NetworkManager.sharedInstance.fetchData(endPoint: .headlines,
                                                params: ["country": "in"],
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
