//
//  Article.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 17/07/21.
//

import Foundation

struct ArticleModal: ModelProtocol {
    var code: String?
    var status: String
    var totalResults: Int
    var articles: [Article]
}

struct Article: Decodable, Hashable {
    var identifier = UUID()
    var source: Source
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: String?
    var content: String?
    
    enum CodingKeys: CodingKey {
        case source,
             author,
             title,
             description,
             url,
             urlToImage,
             publishedAt,
             content
    }
    
    struct Source: Decodable, Hashable {
        var name: String
        var id: String?
        var identifier = UUID()
        
        enum CodingKeys: CodingKey {
            case name,
                 id
        }
    }
}
