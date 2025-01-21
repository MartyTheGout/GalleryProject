//
//  DetailViewController.swift
//  GalleryProject
//
//  Created by marty.academy on 1/17/25.
//

import UIKit
import SnapKit

class DetailViewController : BaseScrollViewController {
    let photo: PhotoData
    
    var photoStaticsData : PhotoStaticsReponse? {
        didSet {
            detailInfoBody.viewedNumber = photoStaticsData?.views.total ?? 0
            detailInfoBody.downloadedNumber = photoStaticsData?.downloads.total ?? 0
            
            let requiredData = [
                "크기":"\(photo.width) x \(photo.height)",
                "조회수": "\(photoStaticsData!.views.total)",
                "다운로드": "\(photoStaticsData!.downloads.total)"
            ]
            
            if let keyValueViews = detailInfoBody.infoHorizontalStackView.arrangedSubviews[1] as? MultipleKeyValueStackVie {
                
                keyValueViews.subviews.forEach {
                    if let view = $0 as? TwoEndedKeyValueView {
                        view.valueLabel.text = requiredData[view.keyLabel.text!]
                    } else {
                        print("this is not an TwoEndedView")
                    }
                }
            } else {
                print("not multikeyvalueview")
            }
        }
    }
    
    lazy var imageHeader: DetailViewImageHeader = {
        let detailViewImageHeader = DetailViewImageHeader(
            width: self.photo.width,
            height: self.photo.height,
            userName: self.photo.user.username,
            userProfileImageURL : self.photo.user.profileImage.small,
            dateInfo: self.photo.createdAt,
            imageURL: self.photo.urls.regular
        )
        return detailViewImageHeader
    }()
    
    lazy var detailInfoBody: DetailViewInfoBody = {
        let detailInfoBody = DetailViewInfoBody(
            width: self.photo.width, height: self.photo.height, downloadedNumber: 0, viewedNumber: 0
        )
        return detailInfoBody
    }()
    
    init(photo: PhotoData) {
        self.photo = photo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.shared.callRequest(api: .statistics(query: photo.id)) { (response : PhotoStaticsReponse)-> Void in
                self.photoStaticsData = response
        }
    }
    
    override func configureViewHierarchy() {
        [imageHeader, detailInfoBody].forEach {
            contentView.addSubview($0)
        }
    }
    
    override func configureViewLayout() {
        imageHeader.snp.makeConstraints {
            $0.top.equalTo(contentView)
            $0.horizontalEdges.equalTo(contentView)
        }
        
        detailInfoBody.snp.makeConstraints {
            $0.top.equalTo(imageHeader.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(contentView)
        }
    }
    
    override func configureViewDesign() {}
    
}
