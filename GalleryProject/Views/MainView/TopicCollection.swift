//
//  TopicCollection.swift
//  GalleryProject
//
//  Created by marty.academy on 1/17/25.
//

import UIKit
import SnapKit

final class TopicCollection: BaseUI {

    let topicTitle = {
       let topicTitle = UILabel()
        topicTitle.textColor = .black
        topicTitle.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return topicTitle
    }()
    
    let collectionView = {
        let layoutInfo = ImageCollectionLayoutInfo()
        
        let leadingInset: CGFloat = layoutInfo.leadingInset
        let itemWidth: CGFloat = layoutInfo.itemWidth
        let itemHeight: CGFloat = layoutInfo.itemHeight
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collectionView
    }()
    
    override func configureViewHierarchy() {
        [topicTitle, collectionView].forEach { addSubview($0) }
    }
    
    override func configureViewLayout() {
        var vertialCoordinateBase: UIView = UIView()
        
        topicTitle.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(20)
        }
        
        vertialCoordinateBase = topicTitle
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(vertialCoordinateBase.snp.bottom).offset(10)
            $0.trailing.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.height.equalTo(ImageCollectionLayoutInfo().itemHeight)
        }
    }
    
    func fillUpData() {
        topicTitle.text = "Title"
    }
}
