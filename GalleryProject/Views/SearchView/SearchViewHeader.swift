//
//  SearchViewHeader.swift
//  GalleryProject
//
//  Created by marty.academy on 1/18/25.
//

import UIKit
import SnapKit

final class SearchViewHeader: BaseUI {

    let searchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    let underlineView = {
        let underlineView = UIView()
        underlineView.backgroundColor = .white
        return underlineView
    }()
    
    let sortButton = {
       let sortButton = UIButton()
//        let blackString = NSAttributedString(string: " 관련순", attributes: [.foregroundColor : UIColor.black])
//        sortButton.setAttributedTitle(blackString, for: .normal)
        sortButton.setTitleColor(.black, for: .normal)
        sortButton.setTitle("관련순", for: .normal)
        
        sortButton.setImage(UIImage(systemName: "equal.square"), for: .normal)
        sortButton.tintColor = .black
        
        sortButton.configuration?.cornerStyle = .capsule
        
        return sortButton
    }()
    
    override func configureViewHierarchy() {
        [searchBar, underlineView].forEach { addSubview($0)}
        
        underlineView.addSubview(sortButton)
    }
    
    override func configureViewLayout() {
        
        searchBar.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.horizontalEdges.equalToSuperview()
        }
        
        let verticalCoordinateBase = searchBar.snp.bottom
        
        underlineView.snp.makeConstraints {
            $0.top.equalTo(verticalCoordinateBase).offset(10)
            $0.horizontalEdges.equalTo(searchBar)
            
        }
        
        sortButton.snp.makeConstraints {
            $0.trailing.equalTo(underlineView)
            $0.top.equalTo(underlineView)
            $0.bottom.equalToSuperview()
        }
    }
}
