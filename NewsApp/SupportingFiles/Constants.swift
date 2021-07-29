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
    
    var imageName: String {
        switch self {
        case .business:
            return "personalhotspot"
        case .entertainment:
            return "camera.metering.center.weighted"
        case .science:
            return "gyroscope"
        case .sports:
            return "gamecontroller.fill"
        case .health:
            return "heart.text.square.fill"
        case .general:
            return "text.bubble.fill"
        case .technology:
            return "network"
        }
    }
    
}
