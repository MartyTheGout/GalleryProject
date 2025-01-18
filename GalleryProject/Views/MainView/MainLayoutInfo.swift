//
//  LayoutInfo.swift
//  GalleryProject
//
//  Created by marty.academy on 1/17/25.
//

import UIKit


struct ImageCollectionLayoutInfo {
    let leadingInset: CGFloat = 20
    var itemWidth: CGFloat {
        ( UIScreen.main.bounds.width - leadingInset ) / 2
    }
    var itemHeight: CGFloat {
        itemWidth * 1.5
    }
}
