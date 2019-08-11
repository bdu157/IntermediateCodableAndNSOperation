//
//  Cache.swift
//  IntermediateCodableAndNSOperation
//
//  Created by Dongwoo Pae on 8/11/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    private var cachedDatas = [Key: Value]()
    
    func cache(value: Value, for key: Key) {
        queue.async {
            self.cachedDatas[key] = value
        }
    }

    func value(for key: Key) -> Value? {
        return queue.sync {self.cachedDatas[key]}
    }
    private let queue = DispatchQueue(label: "cached seriel queue")
}
