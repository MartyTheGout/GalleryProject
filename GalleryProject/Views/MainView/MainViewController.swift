//
//  MainViewController.swift
//  GalleryProject
//
//  Created by marty.academy on 1/17/25.
//

import UIKit
import SnapKit

class MainViewController : BaseScrollViewController {
    
    let headerView = MainViewHeader()
    let firstTopicCollection = TopicCollection()
    let secondTopicCollection = TopicCollection()
    let thirdTopicCollection = TopicCollection()
    
    let numberOfItem = 10
    
    var dataSource: [[PhotoData]] = [[],[],[]] {
        didSet {
            if oldValue[0].count == 0 {
                firstTopicCollection.collectionView.reloadData()
                return
            }
            
            if oldValue[1].count == 0 {
                secondTopicCollection.collectionView.reloadData()
                return
            }
            
            if oldValue[2].count == 0 {
                thirdTopicCollection.collectionView.reloadData()
                return
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var collectionTag = 0
        [firstTopicCollection, secondTopicCollection, thirdTopicCollection].forEach {
            let collectionView = $0.collectionView
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(ImageViewCell.self, forCellWithReuseIdentifier: ImageViewCell.identifier)
            collectionView.tag = collectionTag
            collectionTag += 1
        }
        
        loadDataSource()
    }
    
    override func configureViewHierarchy() {
        [headerView, firstTopicCollection, secondTopicCollection, thirdTopicCollection].forEach { contentView.addSubview($0) }
    }
    
    override func configureViewLayout() {
        headerView.snp.makeConstraints {
            $0.top.equalTo(contentView)
            $0.horizontalEdges.equalTo(contentView).inset(20)
            $0.bottom.equalTo(headerView.mainLabel.snp.bottom).offset(10)
        }
        
        var verticalCoordinateBase : UIView = headerView.mainLabel
        
        [firstTopicCollection, secondTopicCollection, thirdTopicCollection].forEach { topicCollection in
            topicCollection.snp.makeConstraints {
                $0.top.equalTo(verticalCoordinateBase.snp.bottom).offset(10)
                $0.horizontalEdges.equalTo(contentView)
                $0.bottom.equalTo(topicCollection.collectionView.snp.bottom).offset(10)
            }
            verticalCoordinateBase = topicCollection
        }
    }
    
    override func configureViewDesign() {
        let collectionArray = [firstTopicCollection, secondTopicCollection, thirdTopicCollection]
        let topics = RequiredDataForViews.mainViewKeywords.getTexts()
        
        for i in 0...collectionArray.count - 1 {
            collectionArray[i].topicTitle.text = topics[i]
        }
    }
    
    func setHandler(index: Int) -> (_ : [PhotoData]) -> Void {
        return { photoResponse in
            self.dataSource[index] = photoResponse
        }
    }
    
    func loadDataSource() -> Void {
        for i in 0...dataSource.count - 1 {
            let group = dataSource[i]
            if group.count == 0 {
                let searchKeyword = RequiredDataForViews.mainViewKeywords.getQueryString()[i] // 쉽게 괸리할 수 없을까? 복잡하다.
                NetworkManager.shared.getPhotoWith(query: searchKeyword, completionHander: setHandler(index: i))
            }
        }
    }
}

extension MainViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItem
    }
    
    // 이거를 await로 만들어서 사용할 수는 없나?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // No need to have conditional handling for first/second/thirdTopicCollection
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageViewCell.identifier, for: indexPath) as? ImageViewCell {
            let index = returnKeywordIndex(collectionView)
            
            if dataSource[index].count != 0 {
                let photoData = dataSource[index][indexPath.item]
                cell.fillUpData(imageURL: photoData.urls.regular, starNumber: photoData.likes)
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func returnKeywordIndex (_ collectionView : UICollectionView) -> Int {
        if collectionView == firstTopicCollection.collectionView{
            return 0
        } else if collectionView == secondTopicCollection.collectionView {
            return 1
        } else if collectionView == thirdTopicCollection.collectionView {
            return 2
        }
        return 0
    }
}
