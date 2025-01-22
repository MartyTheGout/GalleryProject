//
//  MainViewController.swift
//  GalleryProject
//
//  Created by marty.academy on 1/17/25.
//

import UIKit
import SnapKit

final class MainViewController : BaseScrollViewController {
    
    private let headerView = MainViewHeader()
    private let firstTopicCollection = TopicCollection()
    private let secondTopicCollection = TopicCollection()
    private let thirdTopicCollection = TopicCollection()
    
    private let numberOfItem = 10
    
    private var dataSource: [[PhotoData]] = [[],[],[]]
    
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
    
    private func setHandler(index: Int, group: DispatchGroup) -> (_ : [PhotoData]) -> Void {
        return { photoResponse in
            self.dataSource[index] = photoResponse
            group.leave()
        }
    }
    
    private func loadDataSource() -> Void {
        let dispatchGroup = DispatchGroup()
        
        for i in 0...dataSource.count - 1 {
            let group = dataSource[i]
            if group.count == 0 {
                let searchKeyword = RequiredDataForViews.mainViewKeywords.getQueryString()[i] // 쉽게 괸리할 수 없을까? 복잡하다.
                dispatchGroup.enter()
                NetworkManager.shared.callRequest(
                    api: .topic(query: searchKeyword),
                    completionHandler: setHandler(index: i, group: dispatchGroup),
                    failureHandler: { afError, httpError in
                        dispatchGroup.leave()
                        self.showAlert(title: "Unsplash와의 통신에 문제가 있어요.", message: (httpError?.description ?? afError.errorDescription)!, actionMessage: "관리자에게 문의할게요")
                    }
                )
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            [self.firstTopicCollection.collectionView, self.secondTopicCollection.collectionView, self.thirdTopicCollection.collectionView].forEach { $0.reloadData()}
        }
    }
}

extension MainViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItem
    }
    
    // 이거를 await로 만들어서 사용할 수는 없나?
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // No need to have conditional handling for first/second/thirdTopicCollection
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageViewCell.identifier, for: indexPath) as? ImageViewCell {
            let index = returnKeywordIndex(collectionView)
            
            if dataSource[index].count != 0 {
                let photoData = dataSource[index][indexPath.item]
                cell.fillUpData(imageURL: photoData.urls.thumb, starNumber: photoData.likes)
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    internal func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoAtIndexPath = dataSource[returnKeywordIndex(collectionView)][indexPath.item]
        let detailVC = DetailViewController(photo: photoAtIndexPath )
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func returnKeywordIndex (_ collectionView : UICollectionView) -> Int {
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
