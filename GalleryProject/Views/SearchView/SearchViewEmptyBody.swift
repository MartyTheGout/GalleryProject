//
//  SearchViewEmptyBody.swift
//  GalleryProject
//
//  Created by marty.academy on 1/19/25.
//

import UIKit
import SnapKit

class SearchViewEmptyBody : BaseUI {
    
    let resultLabel = {
        let resultLabel = UILabel()
        resultLabel.font = .boldSystemFont(ofSize: 17)
        return resultLabel
    }()
    
    override func configureViewHierarchy() {
        addSubview(resultLabel)
    }
    
    override func configureViewLayout() {
        resultLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
