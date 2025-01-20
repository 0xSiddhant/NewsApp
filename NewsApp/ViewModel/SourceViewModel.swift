//
//  SourceViewModel.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 26/07/21.
//

import UIKit

class SourceViewModel {
    
    //MARK:- Properties
    var model: SourceModel!
    /// Used to Reload the TableView Content
    @MainActor var reloadTableViewCallBack: (() -> Void)?
    /// CallBack contains list of items which need to reload
    var reloadCellsCallBack: (([Source]) -> Void)?
    var openNewsHomePageCallBack: ((URL) -> Void)
    /// Returns the list of available sources
    var getSourceList: [Source] {
        return model.sources
    }
    var sourceIDCallBack: ((String, String) -> Void)?
    private(set) var previousSelectedIndex = -1
    
    var categoryType: Box<Categories?> = Box(nil)
    
    init(_ openNewsHomePageCallBack: @escaping (URL) -> Void) {
        self.openNewsHomePageCallBack = openNewsHomePageCallBack
    }
    
    //MARK:- Methods
    /// This function is use to manage the UI toggle
    func selectedIndex(_ indx: Int) {
        if indx == previousSelectedIndex {
            previousSelectedIndex = -1
            reloadCellsCallBack?([model.sources[indx]])
            return
        }
        var tempSourceList = [Source]()
        tempSourceList.append(model.sources[indx])
        if previousSelectedIndex != -1 &&
            previousSelectedIndex != indx {
            tempSourceList.append(model.sources[previousSelectedIndex])
        }
        previousSelectedIndex = indx
        reloadCellsCallBack?(tempSourceList)
    }
    
    /// Opens the valid URL of the source if available
    func openSelectedNewsLink(of indx: Int) {
        guard let url = URL(string: model.sources[indx].url) else { return }
        openNewsHomePageCallBack(url)
    }
    
    func setSourceID(of indx: Int) {
        if let lang = Languages.init(rawValue: model.sources[indx].language) {
            UserDefaultsData.language = lang.rawValue
        }
        sourceIDCallBack?(model.sources[indx].id,
                          model.sources[indx].name)
    }
    
    //MARK:- API Call
    func fetchAPI() async {
        var params = [String: Any]()
        if let cat = categoryType.value {
            params["category"] = cat.rawValue
        }
        if !UserDefaultsData.country.isEmpty {
            params["country"] = UserDefaultsData.country
        }
        if !UserDefaultsData.language.isEmpty {
            params["language"] = UserDefaultsData.language
        }
        do {
            await NetworkManager.sharedInstance.toggleLoaderView(true)
            let data = try await NetworkManager.sharedInstance.fetchData(endPoint: .sources,
                                                                             params: params,
                                                                             method: .GET,
                                                                             responseType: SourceModel.self
            )
            self.model = data
            await NetworkManager.sharedInstance.toggleLoaderView(false)
            await self.reloadTableViewCallBack?()
        } catch let error  {
            debugPrint((error as! NewsAPIError).showErrorMessage)
            
        }
    }
}
