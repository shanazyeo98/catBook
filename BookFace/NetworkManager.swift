//
//  NetworkManager.swift
//  BookFace
//
//  Created by Shanaz Yeo on 16/10/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let limit = 10
    lazy var apiURL = "https://dummyjson.com/users/?limit=\(limit)"
    var total: Int?
    
    
    private init() {}
    
    func fetchUsers(for page: Int, completion: @escaping ([User]) -> Void) async {
        
        do {
            let skip: Int = page * limit
            if let total, total <= skip { return completion([]) }
            var finalURL = apiURL
            if skip != 0 {
                finalURL += "&skip=\(skip)"
            }
            print(skip)
            let (data, _) = try await URLSession.shared.data(from: URL(string: finalURL)!)
            
//            if let jsonString = String(data: data, encoding: .utf8) {
//                print("Response JSON: \(jsonString)")
//            }
            
            struct Response: Decodable {
                let users: [User]
                let total: Int
            }
            
            let response = try JSONDecoder().decode(Response.self, from: data)
            var users = response.users
            self.total = response.total
            for index in users.indices {
                let (data, _) = try await URLSession.shared.data(from: URL(string: "https://cataas.com/cat")!)
                users[index].setPicture(data: data)
            }
            completion(users)
        } catch {
            print("Error: \(error)")
        }
        
    }
}
