//
//  SearchViewController.swift
//  GalleryProject
//
//  Created by marty.academy on 1/17/25.
//

import UIKit
import SnapKit

class SearchViewController : BaseViewController {
    let header = SearchViewHeader()
    let body = SearchViewBody()
    
    var searchCriteriaState : SearchCriteria = .relevant

    var dataSource: [PhotoData] = [] {
        didSet {
            body.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        
        header.searchBar.delegate = self
        
        let searchCollectionView = body.collectionView
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.register(ImageViewCell.self, forCellWithReuseIdentifier: ImageViewCell.identifier)
    }
    
    func configureNavigationItem() {
        navigationItem.title = "SEARCH PHOTO"
    }
    
    override func configureViewLayout() {
        [header, body].forEach { view.addSubview($0) }
    }
    
    override func configureViewDesign() {
        header.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(header.sortButton.snp.bottom)
        }
        
        let verticalCoordinateBase = header.snp.bottom
        
        body.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(verticalCoordinateBase).offset(10)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func getPhotos(_ searchKeyword : String, searchCriteria : SearchCriteria) {
        NetworkManager.shared.getPhotoWith(query: searchKeyword, paging: 0, apiClassification: .search, searchCriteria: searchCriteria ) { (photoResponse: SearchPhotoResponse) -> Void in
            if self.searchCriteriaState == searchCriteria {
                self.dataSource = photoResponse.results
                // movelocation 0,0
            } else {
                self.dataSource.append(contentsOf: photoResponse.results)
            }
        }
    }
}

extension SearchViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        print("Search text: \(text)")
        if text.count >= 2 {
            getPhotos(text, searchCriteria: searchCriteriaState)
        } else {
            showAlert(title: "올바른 검색어", message: "2 글자 이상 입력해주세요.", actionMessage: "다시 검색어 입력하기")
        }
    }
}

extension SearchViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageViewCell.identifier , for: indexPath) as? ImageViewCell {
            let photoData = dataSource[indexPath.item]
            cell.usedFrom = .search
            cell.fillUpData(imageURL: photoData.urls.regular, starNumber: photoData.likes)
            return cell
        }
        return UICollectionViewCell()
    }
}
