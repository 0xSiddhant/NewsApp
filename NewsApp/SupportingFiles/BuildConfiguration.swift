//
//  BuildConfiguration.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 19/01/25.
//

import Foundation

final class BuildConfiguration {
    static let shared = BuildConfiguration()
    
    var transportProtocolType: String {
        guard let base = self.infoForKey("TRANSPORT_PROTOCOL_TYPE") else {
            return ""
        }
        return base
    }
    
    var baseURL: String {
        guard let token = self.infoForKey("BASE_URL") else {
            return ""
        }
        return token
    }
    
    var apiKey: String {
        guard let token = self.infoForKey("API_KEY") else {
            return ""
        }
        return token
    }
    
    private init() {
        guard let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String else {
            return
        }
    }
    
    
    private func infoForKey(_ key: String) -> String? {
        (Bundle.main.infoDictionary?[key] as? String)?.replacingOccurrences(of: "\\", with: "")
    }
}
