//
//  Constants.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 20/07/21.
//

import Foundation

enum Categories: String, CaseIterable {
    case business,
         entertainment,
         general,
         health,
         science,
         sports,
         technology
    
    var title: String {
        return rawValue.capitalized
    }
}
