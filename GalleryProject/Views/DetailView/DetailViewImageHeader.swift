//
//  DetailViewImageHeader.swift
//  GalleryProject
//
//  Created by marty.academy on 1/19/25.
//

import UIKit
import SnapKit
import Kingfisher

class DetailViewImageHeader: BaseUI {
    var width : Int
    var height : Int
    var userName : String
    var userProfileImageURL : String
    var dateInfo : String
    var imageURL : String
    
    init(width: Int, height: Int, userName: String, userProfileImageURL: String,  dateInfo: String, imageURL: String) {
        self.width = width
        self.height = height
        self.userName = userName
        self.userProfileImageURL = userProfileImageURL
        self.dateInfo = dateInfo
        self.imageURL = imageURL
        
        super.init(frame: .zero)
        
        configureViewHierarchy()
        configureViewLayout()
        configureViewDesign()
    }
    
    let introducmentInfoSection = UIView()
    
    let userProfileImage: UIImageView = {
        let userProfileImage = UIImageView()
        userProfileImage.contentMode = .scaleAspectFill
        return userProfileImage
    }()
    
    let userNameLabel: UILabel = {
        let userNameLabel = UILabel()
        userNameLabel.font = .systemFont(ofSize: 15)
        return userNameLabel
    }()
    
    let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = .boldSystemFont(ofSize: 13)
        return dateLabel
    }()
    
    let imageSection : UIImageView =  {
        let imageSection = UIImageView()
        imageSection.contentMode = .scaleAspectFill
        return imageSection
    }()
    
    override func configureViewHierarchy() {
        [introducmentInfoSection, imageSection].forEach { addSubview($0) }
        [userProfileImage, userNameLabel, dateLabel].forEach { introducmentInfoSection.addSubview($0) }
    }
    
    override func configureViewLayout() {
        
        introducmentInfoSection.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
        }
        
        userProfileImage.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(10)
            $0.size.equalTo(CGSize(width: 40, height: 40))
        }
        
        let verticalCoordinateBase = userProfileImage.snp.bottom
        let horizontalCoordinateBase = userProfileImage.snp.trailing
        
        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(horizontalCoordinateBase).offset(8)
            $0.top.equalTo(userProfileImage.snp.top).offset(8)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(horizontalCoordinateBase).offset(8)
            $0.top.equalTo(userNameLabel.snp.bottom).offset(4)
        }
        
        introducmentInfoSection.snp.makeConstraints {
            $0.bottom.equalTo(dateLabel.snp.bottom)
        }
        
        imageSection.snp.makeConstraints {
            let aspectRatio = (width > 0 && height > 0) ? CGFloat(height) / CGFloat(width) : 1.0
            $0.top.equalTo(verticalCoordinateBase).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(imageSection.snp.width).multipliedBy(aspectRatio)
            
            $0.bottom.equalToSuperview()
        }
    }
    
    private func convertDateFormat(_ dateInfo : String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = dateFormatter.date(from: dateInfo)!
        
        dateFormatter.dateFormat = "yyyy년MM월dd일 게시됨"
        
        return dateFormatter.string(from: date)
    }
    
    override func configureViewDesign() {
        userProfileImage.layer.masksToBounds = true
        userProfileImage.kf.setImage(with: URL(string: imageURL))
        
        userNameLabel.text = userName
        
        dateLabel.text = convertDateFormat(dateInfo)
        
        imageSection.layer.masksToBounds = true
        imageSection.kf.setImage(with: URL(string: imageURL))
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userProfileImage.layer.cornerRadius = 20
    }
    
}
