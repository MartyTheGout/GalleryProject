//
//  NetworkManager.swift
//  GalleryProject
//
//  Created by marty.academy on 1/17/25.
//

import Foundation
import Alamofire

enum UnsplashRequest {
    case topic(query: String)
    case search(query: String, paging: Int, searchCriteria: SearchCriteria)
    case statistics(query: String)
    
    var baseURL: String { "https://api.unsplash.com/"}
    var dataPerRequest: Int { 20 }
    
    var authorizationHeader: HTTPHeaders {
        return ["Authorization": "\(APIKeys.UnsplashAcessKey.rawValue)"]
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


class NetworkManager {
    static let shared : NetworkManager = NetworkManager()
    let dataPerRequest = 20
    
    private init() {}
    
    func callRequest<T: Decodable>(api: UnsplashRequest,
                                   completionHandler: @escaping (T) -> Void,
                                   failureHandler: (() -> Void)? = nil
    ) {
        AF.request(api.endpoint, method: api.method, headers: api.authorizationHeader).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value)
            case .failure(let error):
                failureHandler?()
                print("Error: \(error)")
            }
        }
    }
}
