//
//  APIErrorCode.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 15/07/21.
//

import Foundation


enum NewsAPIError: Error {
    
    case newsAPIError(value: String)
    case statusCodeError(value: String)
    case unknownError
    
    /// Print String Representation of Error Code
    var showErrorMessage: String {
        switch self {
        case .newsAPIError(let msg) :
            return msg
        case .statusCodeError(let msg) :
            return msg
        default:
            return ""
        }
    }
}

//MARK:- API Error Codes
enum APIErrorCode: String {
    
    init(key: String) {
        switch key {
        case "apiKeyDisabled":
            self = .apiKeyDisabled
        case "apiKeyExhausted":
            self = .apiKeyExhausted
        case "apiKeyInvalid":
            self = .apiKeyInvalid
        case "apiKeyMissing":
            self = .apiKeyMissing
        case "parameterInvalid":
            self = .parameterInvalid
        case "parametersMissing":
            self = .parametersMissing
        case "rateLimited":
            self = .rateLimited
        case "sourcesTooMany":
            self = .sourcesTooMany
        case "sourceDoesNotExist":
            self = .sourceDoesNotExist
        case "unexpectedError":
            self = .unexpectedError
        default:
            self = .unknown
        }
    }
    
    /// Return NewAPIError Object
    var getError: NewsAPIError {
        return NewsAPIError.newsAPIError(value: self.rawValue)
    }
    
    case apiKeyDisabled = "Your API key has been disabled."
    case apiKeyExhausted = "Your API key has no more requests available."
    case apiKeyInvalid = "Your API key hasn't been entered correctly. Double check it and try again."
    case apiKeyMissing = "Your API key is missing from the request. Append it to the request with one of these methods."
    case parameterInvalid = "You've included a parameter in your request which is currently not supported. Check the message property for more details."
    case parametersMissing = "Required parameters are missing from the request and it cannot be completed. Check the message property for more details."
    case rateLimited = "You have been rate limited. Back off for a while before trying the request again."
    case sourcesTooMany = "You have requested too many sources in a single request. Try splitting the request into 2 smaller requests."
    case sourceDoesNotExist = "You have requested a source which does not exist."
    case unexpectedError = "This shouldn't happen, and if it does then it's our fault, not yours. Try the request again shortly."
    case unknown = "Unable to Detect Error"
    
}

//MARK:- API Status Code Message
enum APIStatusCode: String {
    
    init?(rsc: NetworkManager.ResponseStatusCode) {
        switch rsc {
        case .BadRequest:
            self = .BadRequest
        case .Unauthorized:
            self = .Unauthorized
        case .TooManyRequests:
            self = .TooManyRequests
        case .ServerError:
            self = .ServerError
        case .OK:
            return nil
        }
    }
    
    /// Return NewAPIError Object
    var getError: NewsAPIError {
        return NewsAPIError.statusCodeError(value: self.rawValue)
    }
    
    case BadRequest = "The request was unacceptable, often due to a missing or misconfigured parameter."
    case Unauthorized = "Your API key was missing from the request, or wasn't correct."
    case TooManyRequests = "You made too many requests within a window of time and have been rate limited. Back off for a while."
    case ServerError = "Something went wrong on our side."
}
