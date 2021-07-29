//
//  UserDefaultData.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 20/07/21.
//

import Foundation
struct UserDefaultsData {
    @UserDefault("language", defaultValue: "")
    static var language: String
    
    @UserDefault("country", defaultValue: "")
    static var country: String
    
    @propertyWrapper
    struct UserDefault<T> {
        let key: String
        let defaultValue: T
        
        init(_ key: String, defaultValue: T) {
            self.key = key
            self.defaultValue = defaultValue
        }
        
        var wrappedValue: T {
            get {
                return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
            }
            set {
                UserDefaults.standard.set(newValue, forKey: key)
            }
        }
    }
}

