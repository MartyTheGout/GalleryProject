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
    
    let sizeInfoRow: BaseUI = TwoEndedKeyValueView(key: "", value: "")
    
    let viewInfoRow: BaseUI = TwoEndedKeyValueView(key: "", value: "")
    
    let downloadInfoRow: BaseUI = TwoEndedKeyValueView(key: "", value: "")
    
    lazy var infoHorizontalStackView: UIStackView = {
        
        let infoHoriziontalStackView = UIStackView()
        infoHoriziontalStackView.axis = .horizontal
        infoHoriziontalStackView.alignment = .top
        
        let label1 = UILabel()
        label1.attributedText = NSAttributedString(string: "정보", attributes: [
            .font : UIFont.systemFont(ofSize: 22, weight: .bold),
        ])
        
        let infos : [[String]] = [
            ["크기", "\(width) x \(height)"],
            ["조회수", "\(viewedNumber)"],
            ["다운로드", "\(downloadedNumber)"]
        ]
        
        let rightView = UIStackView()
        rightView.axis = .vertical
        rightView.distribution = .equalSpacing
        rightView.spacing = 8
        
        
        var index = 0
        [sizeInfoRow, viewInfoRow, downloadInfoRow].forEach {
            $0.updateViewData(inputData:infos[index] )
            rightView.addArrangedSubview($0)
            index += 1
        }
        
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
    
    override func updateViewData<T>(inputData: T) {
        guard let dictionary = inputData as? [String: String] else {
            dump("[Error on inputData] not allowed typo for DetailViewInfoBody:updateViewData")
            return
        }
        
        [sizeInfoRow, viewInfoRow, downloadInfoRow].forEach {
            guard let twoWayEndedView = $0 as? TwoEndedKeyValueView else { return }
            twoWayEndedView.updateViewData(inputData: dictionary[twoWayEndedView.key])
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
    
    override func updateViewData<T>(inputData: T) {
        
        if let keyValueInOneArray = inputData as? [String] {
            self.key = keyValueInOneArray[0]
            self.value = keyValueInOneArray[1]
            
            keyLabel.text = self.key
            valueLabel.text = self.value
        }
        
        if let inputString = inputData as? String {
            self.value = "\(inputString)"
            valueLabel.text = self.value
        }
    }
}
