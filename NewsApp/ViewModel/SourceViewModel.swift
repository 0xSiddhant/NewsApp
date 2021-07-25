//
//  SourceViewModel.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 26/07/21.
//

import Foundation

class SourceViewModel {
    //MARK:- Properties
    var model: SourceModel!
    /// Used to Reload the TableView Content
    var reloadTableViewCallBack: (() -> Void)?
    /// Returns the list of available sources
    var getSourceList: [Source] {
        return model.sources
    }
    private(set) var previousSelectedIndex = -1
    
    func selectedIndex(_ indx: Int) -> [Source] {
        var tempSourceList = [Source]()
        tempSourceList.append(model.sources[indx])
        if previousSelectedIndex != -1 &&
            previousSelectedIndex != indx {
            tempSourceList.append(model.sources[previousSelectedIndex])
        }
        previousSelectedIndex = indx
        return tempSourceList
    }
    
    func fetchAPI() {
        let params = [String: Any]()
        NetworkManager.sharedInstance.fetchData(endPoint: .sources,
                                                params: params,
                                                method: .GET,
                                                responseType: SourceModel.self
        ) { response in
            switch response {
            case .success(let data):
                self.model = data
                self.reloadTableViewCallBack?()
            case .failure(let error):
                debugPrint(error.showErrorMessage)
            }
        }
    }
}
