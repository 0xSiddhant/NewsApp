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

struct Source: Decodable, Hashable {
    var id: String
    var identifer = UUID()
    var name: String
    var description: String
    var url: String
    var category: String
    var language: String
    var country: String
    
    enum CodingKeys: CodingKey {
        case id,
             name,
             description,
             url,
             category,
             language,
             country
    }
    
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(description)
        hasher.combine(id)
        hasher.combine(name)
        
    }
}
