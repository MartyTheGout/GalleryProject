//
//  MainViewHeader.swift
//  GalleryProject
//
//  Created by marty.academy on 1/17/25.
//

import UIKit

final class MainViewHeader : BaseUI {
    let profileImage = {
        let profileImage = UIImageView()
        profileImage.image = UIImage(systemName: "person.circle.fill")
        return profileImage
    }()
    
    let mainLabel = {
        let mainLabel = UILabel()
        mainLabel.text = "OUR TOPIC"
        mainLabel.font = UIFont(name: "Arial Rounded MT Bold", size: 30)
        return mainLabel
    }()
    
    override func configureViewHierarchy() {
        [profileImage, mainLabel].forEach { addSubview($0) }
    }
    
    override func configureViewLayout() {
        var verticalCoordinateBase : UIView = UIView()
        
        profileImage.snp.makeConstraints {
            $0.top.trailing.equalToSuperview()
            $0.size.equalTo(CGSize(width: 30, height: 30))
        }
        
        verticalCoordinateBase = profileImage
        
        mainLabel.snp.makeConstraints {
            $0.top.equalTo(verticalCoordinateBase.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
        }
    }
}
