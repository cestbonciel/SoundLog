//
//  Observable.swift
//  SoundLog
//
//  Created by Nat Kim on 2024/03/13.
//

import Foundation

class Observable<Value> {
    private var listener: ( (Value) -> Void )?
    
    var value: Value {
        didSet {
            listener?(value)
        }
    }
    
    init(_ value: Value) {
        self.value = value
    }
    
    func bind(_ completion: @escaping (Value) -> Void) {
        completion(value)
        listener = completion
    }
}
