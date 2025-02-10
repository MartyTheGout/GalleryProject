//
//  DetailViewModel.swift
//  GalleryProject
//
//  Created by marty.academy on 2/10/25.
//

import Foundation
import Alamofire

class DetailViewModel : BaseInOut {
    struct Input {
        let photo: Observable<PhotoData>
        
        init(photo: PhotoData) {
            self.photo = Observable(photo)
        }
    }
    
    struct Output {
        let photoStaticsData : Observable<Result<PhotoStaticsReponse, AFError>?> = Observable(nil)
    }
    
    private(set) var input : Input
    private(set) var output : Output
    
    init(photo: PhotoData) {
        self.input = Input(photo: photo)
        self.output = Output()
        
        transform()
    }
    
    func transform() {
        input.photo.bind { [weak self] _ in
            self?.getPhotoStatistics()
        }
    }
}

extension DetailViewModel {
    func getPhotoStatistics() {
        let photoId = input.photo.value.id
        
        NetworkManager.shared.callRequest(api: .statistics(query: photoId)) { (response : Result<PhotoStaticsReponse, AFError>)-> Void in
            self.output.photoStaticsData.value = response
        }
    }
}
