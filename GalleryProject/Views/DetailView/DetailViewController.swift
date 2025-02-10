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
    
    var viewModel: DetailViewModel
    
    //MARK: - View Components
    lazy var imageHeader: DetailViewImageHeader = {
        let photo = self.viewModel.input.photo.value
        
        let detailViewImageHeader = DetailViewImageHeader(
            width: photo.width,
            height: photo.height,
            userName: photo.user.username,
            userProfileImageURL : photo.user.profileImage.small,
            dateInfo: photo.createdAt,
            imageURL: photo.urls.thumb
        )
        return detailViewImageHeader
    }()
    
    lazy var detailInfoBody: DetailViewInfoBody = {
        let photo = self.viewModel.input.photo.value
        
        
        let imageDetail = ImageDetailInfo (width: photo.width, height: photo.height, downloadedNumber: 0, viewedNumber: 0)
        
        let detailInfoBody = DetailViewInfoBody(
            imageDetailInfo: imageDetail
        )
        return detailInfoBody
    }()
    
    init(photo: PhotoData) {
        self.viewModel = DetailViewModel(photo: photo)

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataBindings()
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

extension DetailViewController {
    func setDataBindings() {
        viewModel.output.photoStaticsData.bind { [weak self] response in
            switch response {
            case .success(let data):
                let photoStaticsData = data
                guard let photo = self?.viewModel.input.photo.value else { return }
                
                self?.detailInfoBody.viewModel.input.imageDetailInfo.value = ImageDetailInfo(width: photo.width, height: photo.height, downloadedNumber: photoStaticsData.downloads.total, viewedNumber: photoStaticsData.views.total)
                
                return
            case .failure(let error):
                self?.showAlert(title: "Unsplash와의 통신에 문제가 있어요.", message: error.localizedDescription, actionMessage: "관리자에게 문의할게요")
                return
                
            case .none:
                return
            }
        }
    }
}

//MARK: - ImageDetailInfo Type Declaration
struct ImageDetailInfo {
    let width: Int
    let height: Int
    let downloadedNumber: Int
    let viewedNumber: Int
}
