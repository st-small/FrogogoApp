//
//  NetworkDataFetcher.swift
//  FrogogoApp
//
//  Created by Станислав Шияновский on 10/30/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public protocol DataFetcher {
    func getUsers(response: @escaping ([User]?) -> ())
}

public struct NetworkDataFetcher: DataFetcher {
    
    private let networking: Networking
    
    public init(_ networking: Networking) {
        self.networking = networking
    }
    
    public func getUsers(response: @escaping ([User]?) -> ()) {
        
        networking.request(path: APIConstants.usersList, params: [:]) { (data, error) in
            if let error = error {
                print("Error recieved requesting data: \(error.localizedDescription)")
                response(nil)
            }
            
            let decoded = self.decodeJSON(type: [User].self, from: data)
            response(decoded)
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard
            let data = from,
            let response = try? decoder.decode(type.self, from: data) else { return nil }
        return response
    }
}
