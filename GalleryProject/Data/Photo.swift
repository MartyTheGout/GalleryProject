//
//  Photo.swift
//  GalleryProject
//
//  Created by marty.academy on 1/18/25.
//

import Foundation


struct PhotoStaticsReponse: Codable {
    let id, slug: String
    let downloads, views, likes: TotalAndDetail
}

struct TotalAndDetail: Codable {
    let total: Int
}

struct SearchPhotoResponse : Codable {
    let total: Int
    let totalPages: Int
    let results: [PhotoData]
    
    enum CodingKeys: String, CodingKey {
        case total
        case totalPages = "total_pages"
        case results
    }
}

struct PhotoData: Codable {
    let id, slug: String
    let createdAt, updatedAt: String
    let width, height: Int
    let color, blurHash: String
    var urls : UnsplashURLs
    let likes: Int
    let likedByUser: Bool
    let assetType: String
    let user: User

    enum CodingKeys: String, CodingKey {
        case id, slug
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width, height, color
        case blurHash = "blur_hash"
        case urls, likes
        case likedByUser = "liked_by_user"
        case assetType = "asset_type"
        case user
    }
}

struct User : Codable {
    let id: String
    let username: String
    let profileImage: ProfileImage
    
    enum CodingKeys: String, CodingKey {
        case id, username
        case profileImage = "profile_image"
    }
}

struct ProfileImage: Codable {
    let small, medium, large: String
}

struct UnsplashURLs: Codable {
    let raw, full, regular, small, thumb: String
    
    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
    }
}
