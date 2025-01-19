//
//  DetailViewInfoBody.swift
//  GalleryProject
//
//  Created by marty.academy on 1/19/25.
//

import UIKit
import SnapKit

class DetailViewInfoBody: BaseUI {
    
    var width: Int
    var height: Int
    var downloadedNumber: Int
    var viewedNumber : Int
    
    init(width: Int, height: Int, downloadedNumber: Int, viewedNumber: Int) {
        self.width = width
        self.height = height
        self.downloadedNumber = downloadedNumber
        self.viewedNumber = viewedNumber
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var infoHorizontalStackView: UIStackView = {
        
        let infoHoriziontalStackView = UIStackView()
        infoHoriziontalStackView.axis = .horizontal
        infoHoriziontalStackView.alignment = .top
        
        let label1 = UILabel()
        label1.attributedText = NSAttributedString(string: "정보", attributes: [
            .font : UIFont.systemFont(ofSize: 22, weight: .bold),
        ])
        
        let infos : [String: String] = [
            "크기":"\(width) x \(height)",
            "조회수": "\(viewedNumber)",
            "다운로드": "\(downloadedNumber)"
        ]
        
        let rightView = MultipleKeyValueStackVie(keyAndValues: infos)
        
        infoHoriziontalStackView.addArrangedSubview(label1)
        infoHoriziontalStackView.addArrangedSubview(rightView)
        
        return infoHoriziontalStackView
    }()
    
    
    override func configureViewHierarchy() {
        addSubview(infoHorizontalStackView)
    }
    
    override func configureViewLayout() {
        infoHorizontalStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}


class MultipleKeyValueStackVie : BaseUI {
    
    var keyAndValues: [String: String]
    
    init(keyAndValues: [String: String]) {
        self.keyAndValues = keyAndValues
        super.init(frame: .zero)
    }
    
    override func configureViewHierarchy() {
        keyAndValues.forEach { key, value in
            let twoEndedView = TwoEndedKeyValueView(key: key, value: value)
            addSubview(twoEndedView)
        }
    }
    
    override func configureViewLayout() {
        
        var verticalCoordinateBase = UIView()
        for (i,subView) in subviews.enumerated() {
            subView.snp.makeConstraints {
                if i == 0 {
                    $0.top.equalToSuperview()
                } else {
                    $0.top.equalTo(verticalCoordinateBase.snp.bottom).offset(8)
                }
                
                $0.horizontalEdges.equalToSuperview()
                verticalCoordinateBase = subviews[i]
            }
        }
        
        subviews.last?.snp.makeConstraints {
            $0.bottom.equalToSuperview()
        }
    }
}

class TwoEndedKeyValueView : BaseUI {
    var key: String
    var value : String
    
    init(key: String, value: String) {
        self.key = key
        self.value = value
        super.init(frame: .zero)
    }
    
    let keyLabel: UILabel =  {
        let keyLabel = UILabel()
        keyLabel.attributedText = NSAttributedString(string: "", attributes: [.foregroundColor: UIColor.label])
        return keyLabel
    }()
    
    let valueLabel: UILabel = {
        let valueLabel = UILabel()
        valueLabel.attributedText = NSAttributedString(string: "", attributes: [.foregroundColor: UIColor.label])
        return valueLabel
    }()
    
    override func configureViewHierarchy() {
        [keyLabel, valueLabel].forEach { addSubview($0)}
    }
    
    override func configureViewLayout() {
        keyLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().offset(8)
            $0.leading.equalToSuperview().offset(8)
        }
        
        valueLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-8)
        }
    }
    
    override func configureViewDesign() {
        keyLabel.text = key
        valueLabel.text = value
    }
}
