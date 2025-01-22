//
//  LeftViews.swift
//  GalleryProject
//
//  Created by marty.academy on 1/17/25.
//

import UIKit
import SnapKit

/**
 LeftViews.swift
 
 <개요>
 아직 구현이 예정되지 않은 뷰들의 임시 뷰컨트롤러를 위한 파일입니다.
 */

final class PlayableViewController : BaseViewController {
    let label = {
        let label = UILabel()
        label.text = "In Construction ..."
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureViewLayout() {
        view.addSubview(label)
    }
    
    override func configureViewDesign() {
        label.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}

final class LikeViewController : BaseViewController {
    let label = {
        let label = UILabel()
        label.text = "In Construction ..."
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureViewLayout() {
        view.addSubview(label)
    }
    
    override func configureViewDesign() {
        label.snp.makeConstraints {
            $0.center.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
