//
//  DetailBodyViewModel.swift
//  GalleryProject
//
//  Created by marty.academy on 2/10/25.
//

import Foundation


class DetailBodyViewModel: BaseInOut {
    struct Input {
        let imageDetailInfo : Observable<ImageDetailInfo>
        
        init (imageDetailInfo: ImageDetailInfo) {
            self.imageDetailInfo = Observable(imageDetailInfo)
        }
    }
    
    struct Output {
        let keyValueDict = Observable([String: String]())
    }
    
    var input: Input
    var output: Output

    init(imageDetailInfo: ImageDetailInfo) {
        self.input = Input(imageDetailInfo: imageDetailInfo)
        self.output = Output()
        transform()
    }
    
    func transform() {
        input.imageDetailInfo.bind { [weak self] _ in
            self?.convertToOutputFormat()
        }
    }
}

extension DetailBodyViewModel {
    func convertToOutputFormat() {
        let imageDetailInfo = input.imageDetailInfo.value
        let width = imageDetailInfo.width
        let height = imageDetailInfo.height
        let viewedNumber = imageDetailInfo.viewedNumber
        let downloadedNumber = imageDetailInfo.downloadedNumber
        
        let infos : [String :  String] = [
            "크기" : "\(width) x \(height)",
            "조회수" : "\(viewedNumber)",
            "다운로드" : "\(downloadedNumber)"
        ]
        
        output.keyValueDict.value = infos
    }
    
    func convertOutputToStringArrayFormat() -> [[String]] {
        let keyValueDict = output.keyValueDict.value
        
        let stringArray = keyValueDict.map {
            [$0.key, $0.value]
        }
        
        return stringArray
    }
}
