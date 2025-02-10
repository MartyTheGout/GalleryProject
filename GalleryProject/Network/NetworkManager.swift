//
//  NetworkManager.swift
//  GalleryProject
//
//  Created by marty.academy on 1/17/25.
//

import Foundation
import Alamofire

enum HttpResponseError : Error {
    case incorrectParameters
    case unautorized
    case lackOfPermission
    case noPathExists
    case internalServerError
    case undefinedCode
    
    init?(statusCode: Int) {
        switch statusCode {
        case 400:
            self = .incorrectParameters
        case 401:
            self = .unautorized
        case 403:
            self = .lackOfPermission
        case 404:
            self = .noPathExists
        case 500... :
            self = .internalServerError
        default :
            self = .undefinedCode
        }
    }
    
    var description : String {
        switch self {
            case .incorrectParameters:
                return "[400] Incorrect parameters or body assumed"
            case .unautorized: 
                return "[401] Unautorized Request: Invalid access token"
            case .lackOfPermission: 
                return "[403] Lack of permission: Check the user's permission"
            case .noPathExists: 
                return "[404] No path exists: Confirm base url / path behind"
            case .internalServerError: 
                return "[500] Internal server error: Check the server side notice"
            case .undefinedCode: 
                return "[XXX] Undefined code: Check the response document"
        }
    }
}

enum UnsplashRequest {
    case topic(query: String)
    case search(query: String, paging: Int, searchCriteria: SearchCriteria)
    case statistics(query: String)
    
    var baseURL: String { "https://api.unsplash.com/"}
    var dataPerRequest: Int { 20 }
    
    var authorizationHeader: HTTPHeaders {
        return ["Authorization": "\(APIKeys.UnsplashAccessKey.rawValue)"]
    }
    
    var method: HTTPMethod { .get }
    
    var endpoint: URL {
        switch self {
        case .topic(let query): return URL(string: baseURL + "topics/\(query)/photos?page=1" )!
        case .search(let query, let paging, let searchCriteria): return URL(string: baseURL + "search/photos?query=\(query)&page=\(paging)&per_page=\(dataPerRequest)&order_by=\(searchCriteria.rawValue)")!
        case .statistics(let query): return URL(string: baseURL + "photos/\(query)/statistics")!
        }
    }
}

final class NetworkManager {
    static let shared : NetworkManager = NetworkManager()
    let dataPerRequest = 20
    
    private init() {}
    
    func callRequest<T: Decodable>(api: UnsplashRequest,
                                   completionHandler: @escaping (Result<T, AFError>) -> Void
    ) {
        AF.request(api.endpoint, method: api.method, headers: api.authorizationHeader).responseDecodable(of: T.self) { response in
            completionHandler(response.result)
        }
    }
}
