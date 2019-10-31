//
//  NetworkDataFetcher.swift
//  FrogogoApp
//
//  Created by Станислав Шияновский on 10/30/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public protocol DataFetcher {
    func getUsers(response: @escaping (_ data: [User]?, _ error: Error?) -> ())
    func addUser(userModel: UserModel, response: @escaping (_ success: Bool, _ error: String?) -> ())
    func updateUser(userModel: User, response: @escaping (_ success: Bool, _ error: String?) -> ())
}

public struct NetworkDataFetcher: DataFetcher {
    
    private let networking: Networking
    
    public init(_ networking: Networking) {
        self.networking = networking
    }
    
    public func getUsers(response: @escaping ([User]?, Error?) -> ()) {

        networking.request(path: APIConstants.usersList, method: .get, body: nil) { (data, error, _) in
            if let error = error {
                print("Error recieved requesting data: \(error.localizedDescription)")
                response(nil, error)
            }

            let decoded = self.decodeJSON(type: [User].self, from: data)
            response(decoded, nil)
        }
    }
    
    public func addUser(userModel: UserModel, response: @escaping (Bool, String?) -> ()) {
        let model = UserWrappedModel(firstName: userModel.name,
                                     lastName: userModel.lastName,
                                     email: userModel.email,
                                     avatarUrl: "")
        let params = UserWrappedResponse(user: model)
        let encoded = self.encode(params)
        
        networking.request(path: APIConstants.addUser, method: .post, body: encoded) { (data, error, code) in
            if let error = error {
                let errorMessage = "Error recieved requesting data: \(error.localizedDescription)"
                response(false, errorMessage)
            }
            
            guard let code = code else {
                let errorMessage = "Something went wrong..."
                response(false, errorMessage)
                return
            }
            
            if (200..<300).contains(code) {
                response(true, nil)
            } else {
                let decoded = self.decodeJSON(type: DataResponse.self, from: data)
                let status = decoded?.status ?? 400
                let error = decoded?.error ?? ""
                let errorMessage = "Error code: \(status)\n\(error)"
                response(false, errorMessage)
            }
        }
    }
    
    public func updateUser(userModel: User, response: @escaping (Bool, String?) -> ()) {
        let model = UserWrappedModel(firstName: userModel.firstName,
                                     lastName: userModel.lastName,
                                     email: userModel.email,
                                     avatarUrl: "")
        let params = UserWrappedResponse(user: model)
        let encoded = self.encode(params)
        let path = "\(APIConstants.updateUser)\(userModel.id).json"
        networking.request(path: path, method: .patch, body: encoded) { (data, error, code) in
            
            if let error = error {
                let errorMessage = "Error recieved requesting data: \(error.localizedDescription)"
                response(false, errorMessage)
            }
            
            guard let code = code else {
                let errorMessage = "Something went wrong..."
                response(false, errorMessage)
                return
            }
            
            if (200..<300).contains(code) {
                response(true, nil)
            } else {
                let decoded = self.decodeJSON(type: DataResponse.self, from: data)
                let status = decoded?.status ?? 400
                let error = decoded?.error ?? ""
                let errorMessage = "Error code: \(status)\n\(error)"
                response(false, errorMessage)
            }
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
    
    private func encode<T>(_ value: T) -> Data? where T: Encodable {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.outputFormatting = .prettyPrinted
        guard let response = try? encoder.encode(value) else { return nil }
        return response
    }
}
