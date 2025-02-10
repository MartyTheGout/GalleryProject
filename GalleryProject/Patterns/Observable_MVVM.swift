//
//  Observable_MVVM.swift
//  GalleryProject
//
//  Created by marty.academy on 2/10/25.
//

import Foundation

class Observable<T> {
    enum Observer {
        case newValueObserver(closure: (T) -> Void)
        case newAndOldValueObserver(closure: (T,T) -> Void)
    }
    
    var observer : Observer?
    
    var value : T {
        didSet {
            switch observer {
            case .newValueObserver(let closure):
                closure(value)
                return
            case .newAndOldValueObserver(let closure):
                closure(oldValue,value)
                return
            case nil:
                return
            }
        }
    }
    
    init (_ value: T) {
        self.value = value
    }
    
    func bind(closure: @escaping (T)-> Void) {
        observer = .newValueObserver(closure: closure)
        closure(value)
    }
    
    func lazyBind(closure: @escaping (T) -> Void) {
        observer = .newValueObserver(closure: closure)
    }
    
    func lazyBind(closure: @escaping (T,T) -> Void) {
        observer = .newAndOldValueObserver(closure: closure)
    }
}
