//
//  LayoutInfo.swift
//  GalleryProject
//
//  Created by marty.academy on 1/17/25.
//

import UIKit


struct SearchCollectionLayoutInfo {
    let itemSpacing: CGFloat = 10
    var itemWidth: CGFloat {
        ( UIScreen.main.bounds.width - itemSpacing ) / 2
    }
    var itemHeight: CGFloat {
        itemWidth * 1.3
    }
}
