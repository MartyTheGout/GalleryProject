//
//  SearchViewController.swift
//  GalleryProject
//
//  Created by marty.academy on 1/17/25.
//

import UIKit
import SnapKit

final class SearchViewController : BaseViewController {
    private let header = SearchViewHeader()
    private let body = SearchViewBody()
    private let emptyBody = SearchViewEmptyBody()
    
    var dataSource: [PhotoData] = [] {
        didSet {
            body.collectionView.reloadData()
            controlSearchResultOnView()
        }
    }
    
    var currentKeyword = ""
    var currentSearchCriteria : SearchCriteria = .relevant
    var currentPage = 1
    
    var allowNextSearch: Bool {
        ( dataSource.count / currentPage) == NetworkManager.shared.dataPerRequest
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        
        header.searchBar.delegate = self
        
        let searchCollectionView = body.collectionView
        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        searchCollectionView.prefetchDataSource = self
        searchCollectionView.register(ImageViewCell.self, forCellWithReuseIdentifier: ImageViewCell.identifier)
        
        header.sortButton.addTarget(self, action: #selector(changeSearchFilter) , for: .touchUpInside)
    }
    
    private func configureNavigationItem() {
        navigationItem.title = "SEARCH PHOTO"
    }
    
    private func controlSearchResultOnView() {
        if dataSource.isEmpty {
            emptyBody.isHidden = false
            
            if currentKeyword == "" && header.searchBar.text == "" {
                emptyBody.resultLabel.text = "사진을 검색해보세요."
            } else {
                emptyBody.resultLabel.text = "검색 결과가 없어요."
            }
            
        } else {
            emptyBody.isHidden = true
        }
    }
    
    override func configureViewHierarchy() {
        [header, body, emptyBody].forEach { view.addSubview($0) }
    }
    
    override func configureViewLayout() {
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
        
        emptyBody.snp.makeConstraints {
            $0.edges.equalTo(body)
        }
    }
    
    override func configureViewDesign() {
        controlSearchResultOnView()
    }
    
    @objc
    private func changeSearchFilter() {
        let newSearchCriteria : SearchCriteria = currentSearchCriteria == .relevant ? .latest : .relevant
        getPhotos(currentKeyword, searchCriteria: newSearchCriteria)
        header.sortButton.setTitle(newSearchCriteria.getbuttonText(), for: .normal)
        //                    self.header.sortButton.setTitle(searchCriteria.getbuttonText(), for: .normal) // TODO: attributedTitle 과는 작동하지 않는다. => sortButton 과도 확인해보기. 
        //                    self.header.sortButton.titleLabel?.text = searchCriteria.getbuttonText()
    }
    
    private func getPhotos(_ searchKeyword : String, searchCriteria : SearchCriteria, paging: Int = 1 ) {
        
        NetworkManager.shared.callRequest(api: .search(query: searchKeyword, paging: paging, searchCriteria: searchCriteria) ) { (photoResponse: SearchPhotoResponse) -> Void in
            
            if self.currentSearchCriteria == searchCriteria && self.currentKeyword == searchKeyword{
                self.dataSource.append(contentsOf: photoResponse.results)
            } else {
                self.dataSource = photoResponse.results
            
                if !self.dataSource.isEmpty {
                    self.body.collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
                }
                
                self.currentPage = 1
                
                if self.currentSearchCriteria != searchCriteria { // TODO: not working as expected
                    self.currentSearchCriteria = searchCriteria
                }
            }
            self.currentKeyword = searchKeyword
        } failureHandler: { afError, httpError in
            self.showAlert(title: "Unsplash와의 통신에 문제가 있어요.", message: (httpError?.description ?? afError.errorDescription)!, actionMessage: "관리자에게 문의할게요")
        }
    }
}

extension SearchViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else { return }
        if text.count >= 2 {
            getPhotos(text, searchCriteria: currentSearchCriteria)
            
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
            cell.fillUpData(imageURL: photoData.urls.thumb, starNumber: photoData.likes)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoData = dataSource[indexPath.item]
        let detailVC = DetailViewController(photo: photoData)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension SearchViewController : UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if (dataSource.count - 5 <= indexPath.item) && allowNextSearch {
                currentPage += 1
                getPhotos(currentKeyword, searchCriteria: currentSearchCriteria, paging: currentPage)
            }
        }
    }
}
