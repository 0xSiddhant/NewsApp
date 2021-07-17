//
//  Article.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 17/07/21.
//

import Foundation

struct ArticleModal: Decodable {
    var status: String
    var totalResults: Int
    var articles: [Article]
}

struct Article: Decodable {
    var source: Source
    var author: String
    var title: String
    var description: String
    var url: String
    var urlToImage: String
    var publishedAt: String
    var content: String
    
    struct Source: Decodable {
        var name: String
        var id: String
    }
}
