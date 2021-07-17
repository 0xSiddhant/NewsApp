//
//  Source.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 17/07/21.
//

import Foundation

struct SourceModel: ModelProtocol {
    var code: String?
    var status: String
    var sources: [Source]
}

struct Source: Decodable {
    var id: String
    var name: String
    var description: String
    var url: String
    var category: String
    var language: String
    var country: String
    
}
