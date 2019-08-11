//
//  Users.swift
//  IntermediateCodableAndNSOperation
//
//  Created by Dongwoo Pae on 8/10/19.
//  Copyright © 2019 Dongwoo Pae. All rights reserved.
//

import Foundation

struct Users: Codable {
    
    enum ResultKey: String, CodingKey {
        case results
    }
    
    let results: [User]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResultKey.self)
        self.results = try container.decode([User].self, forKey: .results)
    }
}

struct User: Codable{
    
    enum UserKeys: String, CodingKey {
        case name
        case email
        case phone
        case picture
        
        enum NameKeys: String, CodingKey {
            case title
            case first
            case last
        }
        
        enum pictureKeys: String, CodingKey {
            case large
            case medium
            case thumbnail
        }
    }
    
    let title: String
    let first: String
    let last: String
    let email: String
    let phone: String
    let large: String
    let medium: String
    let thumbnail: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UserKeys.self)
        
        let nameContainer = try container.nestedContainer(keyedBy: UserKeys.NameKeys.self, forKey: .name)
        self.title = try nameContainer.decode(String.self, forKey: .title)
        self.first = try nameContainer.decode(String.self, forKey: .first)
        self.last = try nameContainer.decode(String.self, forKey: .last)
        
        self.email = try container.decode(String.self, forKey: .email)
        self.phone = try container.decode(String.self, forKey: .phone)

        let pictureContainer = try container.nestedContainer(keyedBy: UserKeys.pictureKeys.self, forKey: .picture)
        self.large = try pictureContainer.decode(String.self, forKey: .large)
        self.medium = try pictureContainer.decode(String.self, forKey: .medium)
        self.thumbnail = try pictureContainer.decode(String.self, forKey: .thumbnail)
    }
}
