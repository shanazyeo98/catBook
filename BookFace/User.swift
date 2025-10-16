//
//  User.swift
//  BookFace
//
//  Created by Shanaz Yeo on 16/10/25.
//

import Foundation

nonisolated struct User: Decodable, Hashable {
    let id: Int
    let fullName: String
    let profileImage: String
    let city: String
    let state: String
    let birthDate: String
    var picture: Data? = nil
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case profileImage = "image"
        case address
        case birthDate
    }
    
    enum AddressCodingKeys: String, CodingKey {
        case city
        case state
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        
        let firstName = try container.decode(String.self, forKey: .firstName)
        let lastName = try container.decode(String.self, forKey: .lastName)
        self.fullName = "\(firstName) \(lastName)"
        
        self.profileImage = try container.decode(String.self, forKey: .profileImage)
        
        let addressContainer = try container.nestedContainer(keyedBy: AddressCodingKeys.self, forKey: .address)
        self.city = try addressContainer.decode(String.self, forKey: .city)
        self.state = try addressContainer.decode(String.self, forKey: .state)
        
        self.birthDate = try container.decode(String.self, forKey: .birthDate)
    }
    
    mutating func setPicture(data: Data) {
        picture = data
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
