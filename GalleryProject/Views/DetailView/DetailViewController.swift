//
//  DetailViewController.swift
//  GalleryProject
//
//  Created by marty.academy on 1/17/25.
//

import UIKit
import SnapKit
import Alamofire

final class DetailViewController : BaseScrollViewController {
    private let photo: PhotoData
    
    private var photoStaticsData : PhotoStaticsReponse? {
        didSet {
            let requiredData = [
                "크기":"\(photo.width) x \(photo.height)",
                "조회수": "\(photoStaticsData!.views.total)",
                "다운로드": "\(photoStaticsData!.downloads.total)"
            ]
            
            detailInfoBody.updateViewData(inputData: requiredData)
        }
    }
    
    //MARK: - View Components
    lazy var imageHeader: DetailViewImageHeader = {
        let detailViewImageHeader = DetailViewImageHeader(
            width: self.photo.width,
            height: self.photo.height,
            userName: self.photo.user.username,
            userProfileImageURL : self.photo.user.profileImage.small,
            dateInfo: self.photo.createdAt,
            imageURL: self.photo.urls.thumb
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
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //NetworkManager => completion handlr 로 고치고 시작합니다.
        NetworkManager.shared.callRequest(api: .statistics(query: photo.id)) { (response : Result<PhotoStaticsReponse, AFError> ) -> Void in
            
            switch response {
            case .success(let data):
                self.photoStaticsData = data
            case .failure(let error):
                self.showAlert(title: "Unsplash와의 통신에 문제가 있어요.", message: error.localizedDescription, actionMessage: "관리자에게 문의할게요")
            }

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
}
