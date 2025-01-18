//
//  NetworkManager.swift
//  GalleryProject
//
//  Created by marty.academy on 1/17/25.
//

import Foundation
import Alamofire

class NetworkManager {
    static let shared : NetworkManager = NetworkManager()
    
    private init() {}
    
    func getPhotoWith(query: String, paging: Int = 1) async -> [PhotoData] {
        var url = RequiredDataForNetwork.baseURL.rawValue
        url += "/topics/\(query)/photos?page=1"
        
        let authorizationHeader: HTTPHeaders = ["Authorization": "\(APIKeys.UnsplashAcessKey)"]
    
        let response = AF.request(url, method: .get, encoding:JSONEncoding.default, headers: authorizationHeader).responseString { _ in }.serializingDecodable([PhotoData].self)
        
        do {
            return try await response.value
        } catch {
            print(error)
            return []
        }
    }
    
    func getPhotoWith<T: Decodable>(query: String,
                      paging: Int = 1,
                      apiClassification: APIClassification = APIClassification.topic,
                      searchCriteria : SearchCriteria = SearchCriteria.relevant,
                      completionHander: @escaping (T) -> Void ) -> Void {
        var url = RequiredDataForNetwork.baseURL.rawValue
        
        let dataPerRequest = 20
        
        switch apiClassification {
        case .topic:
            url += "/topics/\(query)/photos?page=1"
        case . search:
            url += "/search/photos?query=\(query)&page=\(paging)&per_page=\(dataPerRequest)"
            
            switch searchCriteria {
            case .latest:
                url += "&order_by=latest"
            case .relevant:
                url += "&order_by=relevant"
            }
        case .staticalData:
            url += ""
        }
        
        let authorizationHeader: HTTPHeaders = ["Authorization": "\(APIKeys.UnsplashAcessKey.rawValue)"]
        
        AF.request(url, method: .get,headers: authorizationHeader).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completionHander(value)
            case .failure(let value):
                print(value)
            }
        }
    }
    
    
}
