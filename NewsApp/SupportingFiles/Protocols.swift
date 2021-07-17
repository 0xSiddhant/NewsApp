//
//  Protocols.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 17/07/21.
//

import Foundation

protocol ModelProtocol: Decodable {
    var status: String { get set }
    var code: String? { get set }
}
