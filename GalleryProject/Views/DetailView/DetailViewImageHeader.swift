//
//  DetailViewImageHeader.swift
//  GalleryProject
//
//  Created by marty.academy on 1/19/25.
//

import UIKit
import SnapKit
import Kingfisher

final class DetailViewImageHeader: BaseUI {
    let viewModel : DetailHeaderViewModel
    
    init(width: Int, height: Int, userName: String, userProfileImageURL: String,  dateInfo: String, imageURL: String) {
        
        let imageHeader = ImageHeader(width: width, height: height, userName: userName, userProfileImageURL: userProfileImageURL, dateInfo: dateInfo, imageURL: imageURL)
        
        self.viewModel = DetailHeaderViewModel(imageHeader: imageHeader)
        
        super.init(frame: .zero)
        
        configureViewHierarchy()
        configureViewLayout()
        configureViewDesign()
        
        setDataBindings()
    }
    
    
    //MARK: - View Components
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
    
    //MARK: - View Life Cycle
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
            
            let imageHeader = viewModel.output.imageHeader.value
            let width = imageHeader.width
            let height = imageHeader.height
            
            let aspectRatio = (width > 0 && height > 0) ? CGFloat(height) / CGFloat(width) : 1.0
            $0.top.equalTo(verticalCoordinateBase).offset(20)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(imageSection.snp.width).multipliedBy(aspectRatio)
            
            $0.bottom.equalToSuperview()
        }
    }
    
    override func configureViewDesign() {}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userProfileImage.layer.cornerRadius = 20
    }
}


//MARK: - Data Bindings
extension DetailViewImageHeader {
    func setDataBindings() {
        viewModel.output.imageHeader.bind { [weak self] value in
            self?.userProfileImage.layer.masksToBounds = true
            self?.userProfileImage.kf.setImage(with: URL(string: value.userProfileImageURL))
            
            self?.userNameLabel.text = value.userName
            
            self?.dateLabel.text = self?.viewModel.convertDateFormat(value.dateInfo)
            
            self?.imageSection.layer.masksToBounds = true
            self?.imageSection.kf.setImage(with: URL(string: value.imageURL))
        }
        
    }
}
