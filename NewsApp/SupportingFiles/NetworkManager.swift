//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Siddhant Kumar on 14/07/21.
//

import Alamofire
import UIKit
import ConfigurationModule


class NetworkManager {
    
    private init() { }
    static let sharedInstance = NetworkManager()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .systemGreen
        return activityIndicator
    }()
    
    func fetchData<T: ModelProtocol>(endPoint: APIEndPoint,
                   params: [String: Any],
                   method: APIMethodsType,
                   responseType: T.Type,
                   controller: UIViewController?,
                   completion: @escaping ((Result<T, NewsAPIError>) -> Void)) {
        
        let fullyQualifiedURL = NewsAppConfigurator.BASE_URL.rawValue + endPoint.rawValue
        
        var finalParam = [String: Any]()
        finalParam = params
        finalParam["apiKey"] = NewsAppConfigurator.APIKey.rawValue
        
        debugPrint(fullyQualifiedURL)
        debugPrint(finalParam)
        
        toggleLoaderView(true, controller: controller)
        
        AF.request(fullyQualifiedURL,
                   method: APIMethod(method),
                   parameters: finalParam)
            .validate()
            .response{ [self] response in
                toggleLoaderView(false, controller: controller)
                switch getStatusCode(code: response.response?.statusCode) {
                case .success(_) :
                    switch response.result {
                    case .success(let responseData):
                        guard let data = responseData else { return }
                        do {
                            let model = try JSONDecoder().decode(T.self, from: data)
//                            debugPrint(model)
                            if model.status == "error",
                               let errorCode = model.code {
                                completion(.failure(APIErrorCode(key: errorCode).getError))
                                return
                            }
                            completion(.success(model))
                        } catch {
                            debugPrint(error)
                            completion(.failure(.jsonDecodingError(value: error.localizedDescription)))
                        }
                    case .failure(let error):
                        debugPrint(error)
                        break
                    //FIXME: need to handle network error
                    }
                    
                case .failure(let error):
                    if error.showErrorMessage.isEmpty {
                        //FIXME: need to handle network error
                    }
                    completion(.failure(error))
                    return
                }
                
            }
    }
    
    private func toggleLoaderView(_ show: Bool, controller: UIViewController?) {
        guard let controller = controller else {
            return
        }
        controller.view.isUserInteractionEnabled = !show
        if show {
            controller.view.addSubview(activityIndicator)
            controller.view.bringSubviewToFront(activityIndicator)
            activityIndicator.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor).isActive = true
            activityIndicator.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor).isActive = true
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
}

//MARK:- Enum Lists
extension NetworkManager {
    enum APIMethodsType {
        case GET,
             PUT,
             POST,
             DELETE
    }
    
    enum ResponseStatusCode: Int {
        
        init(_ code: Int) {
            switch code {
            case 200:
                self = .OK
            case 400:
                self = .BadRequest
            case 401:
                self = .Unauthorized
            case 429:
                self = .TooManyRequests
            case 500:
                self = .ServerError
            default:
                self = .OK
            }
        }
        
        case OK = 200
        case BadRequest = 400
        case Unauthorized = 401
        case TooManyRequests = 429
        case ServerError = 500
    }
}

//MARK:- UTILs Methods
extension NetworkManager {
    private func APIMethod(_ mtd:APIMethodsType) -> HTTPMethod {
        switch mtd {
        case .GET:
            return .get
        case .POST:
            return .post
        case .DELETE:
            return .delete
        case .PUT:
            return .put
        }
    }
    
    
    private func getStatusCode(code: Int?) -> Result<ResponseStatusCode, NewsAPIError> {
        guard let code = code else {
            return .failure(NewsAPIError.unknownError)
        }
        let respCode = ResponseStatusCode(code)
        if respCode == .OK {
            return .success(.OK)
        }
        if let error = APIStatusCode(rsc: respCode) {
            return .failure(error.getError)
        }
        return .failure(NewsAPIError.unknownError)
    }
}
