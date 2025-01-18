//
//  RequiredData.swift
//  GalleryProject
//
//  Created by marty.academy on 1/17/25.
//

import Foundation

enum RequiredDataForViews: Int {
    case mainViewKeywords
    
    func getTexts() -> [String] {
        switch self {
        case .mainViewKeywords : return [ "골든 아워", "비즈니스 및 업무", "건축 및 인테리어"]
        }
    }
    
    func getQueryString() -> [String] {
        switch self {
        case .mainViewKeywords : return [ "golden-hour", "business-work", "architecture-interior"]
        }
    }
}

