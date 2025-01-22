//
//  SearchViewBody.swift
//  GalleryProject
//
//  Created by marty.academy on 1/18/25.
//

import UIKit
import SnapKit

final class SearchViewBody: BaseUI {

    let collectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let layoutInfo = SearchCollectionLayoutInfo()
        
        flowLayout.scrollDirection = .vertical
        flowLayout.minimumInteritemSpacing = layoutInfo.itemSpacing
        flowLayout.minimumLineSpacing = layoutInfo.itemSpacing
        flowLayout.itemSize = CGSize(width: layoutInfo.itemWidth, height: layoutInfo.itemHeight)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        
        return collectionView
    }()
    
    override func configureViewHierarchy() {
        addSubview(collectionView)
    }
    
    override func configureViewLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

}
