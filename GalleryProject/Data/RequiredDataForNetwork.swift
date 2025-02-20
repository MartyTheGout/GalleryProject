//
//  RequiredDataForNetwork.swift
//  GalleryProject
//
//  Created by marty.academy on 1/17/25.
//

import Foundation

enum RequiredDataForNetwork: String {
    case baseURL = "https://api.unsplash.com"
}

enum APIClassification : Int {
    case topic
    case search
    case staticalData
}

enum SearchCriteria : Int {
    case relevant
    case latest
    
    func getbuttonText() -> String {
        switch self {
        case .relevant: return "관련순"
        case .latest: return "최신순"
        }
    }
}
