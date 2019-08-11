//
//  FetchPhotoOperation.swift
//  IntermediateCodableAndNSOperation
//
//  Created by Dongwoo Pae on 8/11/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

class FetchPhotoOperation: ConcurrentOperation {
    var imageData: Data?
    var dataTask: URLSessionDataTask?
    var user: User
    
    override func start() {
        state = .isExecuting
        
        let request = URL(string: self.user.thumbnail)!
        
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
            if self.isCancelled {return}
            
            if let error = error {
                print(error)
                return
            }
            
            defer {self.state = .isFinished}
            self.imageData = data
        }
        task.resume()
        self.dataTask = task
    }
    
    override func cancel() {
        dataTask?.cancel()
    }
    
    init(user: User) {
        self.user = user
    }
}
