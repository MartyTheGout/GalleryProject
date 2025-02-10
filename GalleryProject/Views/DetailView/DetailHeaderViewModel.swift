//
//  DetailHeaderViewModel.swift
//  GalleryProject
//
//  Created by marty.academy on 2/10/25.
//

import Foundation

class DetailHeaderViewModel : BaseInOut {
    struct Input {}
    
    struct Output {
        let imageHeader : Observable<ImageHeader>
        
        init(imageHeader: ImageHeader) {
            self.imageHeader = Observable(imageHeader)
        }
    }
    
    var input: Input
    var output: Output
    
    init(imageHeader: ImageHeader) {
        input = Input()
        output = Output(imageHeader: imageHeader)
        
        transform()
    }
    
    func transform() {}
}

extension DetailHeaderViewModel {
    func convertDateFormat(_ dateInfo : String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let date = dateFormatter.date(from: dateInfo)!
        
        dateFormatter.dateFormat = "yyyy년MM월dd일 게시됨"
        
        return dateFormatter.string(from: date)
    }
}


struct ImageHeader {
    var width : Int
    var height : Int
    var userName : String
    var userProfileImageURL : String
    var dateInfo : String
    var imageURL : String
}
