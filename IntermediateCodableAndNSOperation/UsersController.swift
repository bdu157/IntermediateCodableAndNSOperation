//
//  UsersController.swift
//  IntermediateCodableAndNSOperation
//
//  Created by Dongwoo Pae on 8/11/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case otherError
    case noImageData
}

class UsersController {
    
    var users = [User]()
    
    var baseURL = URL(string: "https://randomuser.me/api")!
    //https://randomuser.me/api/?format=json&inc=name,email,phone,picture&results=1000
    func getUsers(numberOfResults: Int, completion: @escaping (Error?)->Void) {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        let formatQueryItem = URLQueryItem(name: "format", value: "json")
        let incQueryItem = URLQueryItem(name: "inc", value: "name,email,phone,picture")
        let resultsQueryItem = URLQueryItem(name: "results", value: String(numberOfResults))
        urlComponents?.queryItems = [formatQueryItem, incQueryItem, resultsQueryItem]
        
        guard let requestURL = urlComponents?.url else {
            NSLog("there is no URL")
            return
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error)
                completion(error)
                return 
            }
            
            guard let data = data else {
                print("there is no data")
                completion(NSError())
                return
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let userDatas = try jsonDecoder.decode(Users.self, from: data)
                self.users = userDatas.results
                //print(userDatas)
                completion(nil)
            } catch {
                NSLog("there is no decoding from API")
                completion(error)
            }
        }.resume()
    }
    
    func getImages(for urlString: String, completion:@escaping (Result<Data, NetworkError>) -> Void) {

        guard let imageURL = URL(string: urlString) else {return}
    
        var request = URLRequest(url: imageURL)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let _  = error {
                completion(.failure(.otherError))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noImageData))
                return
            }
            completion(.success(data))
        }.resume()
    }
}
