//
//  Box.swift
//  NewsApp
//
//  Created by Siddhant Kumar on 20/07/21.
//

class Box<T> {
    typealias Listener = (T) -> Void
    var listener: Listener?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    init(_ data: T) {
        self.value = data
    }
    
    func bind(listener: @escaping Listener) {
        self.listener = listener
        listener(value)
    }
}
