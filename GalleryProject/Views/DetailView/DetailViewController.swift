//
//  DetailViewController.swift
//  GalleryProject
//
//  Created by marty.academy on 1/17/25.
//

import UIKit
import SnapKit

class DetailViewController : BaseViewController {
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
