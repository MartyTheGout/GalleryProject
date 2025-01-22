//
//  ImageViewCell.swift
//  GalleryProject
//
//  Created by marty.academy on 1/17/25.
//

import UIKit
import Kingfisher

final class ImageViewCell : BaseCollecionViewCell {
    
    private let imageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .orange
        return imageView
    }()
    
    private let starLabel = {
        let starLabel = UILabel()
        starLabel.backgroundColor = .darkGray
        starLabel.textColor = .white
        starLabel.font = .systemFont(ofSize: 13)
        
        return starLabel
    }()
    
    var usedFrom : APIClassification = APIClassification.topic
    
    override func configureViewHierarchy() {
        [imageView, starLabel].forEach { addSubview($0)}
    }
    
    override func configureViewLayout() {
        let fixedInset = 8
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        starLabel.snp.makeConstraints{
            $0.leading.equalToSuperview().offset(fixedInset)
            $0.bottom.equalToSuperview().offset(-fixedInset)
            $0.height.equalTo(30)
        }
    }
    
    func fillUpData(imageURL: String, starNumber: Int) {
        imageView.kf.setImage(with: URL(string: imageURL))
        
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        
        let formattedNumber = numberFormat.string(from: NSNumber(value: starNumber)) ?? ""
        starLabel.text = "  ⭐️ \(formattedNumber)  "
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        starLabel.clipsToBounds = true
        starLabel.layer.cornerRadius = starLabel.frame.height / 2
        
        if usedFrom == .topic {
            
            imageView.layer.cornerRadius = 10
        }
    }
}
