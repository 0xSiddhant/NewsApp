//
//  APIEndPoints.swift
//  WeatherApp
//
//  Created by Siddhant Kumar on 15/07/21.
//

import Foundation


/// This Enum contanis the list of endpoints of NewAPI
enum APIEndPoint: String {
    
    case everything = "/v2/everything"
    case headlines = "/v2/top-headlines"
    case sources = "/v2/top-headlines/sources"
    
}
