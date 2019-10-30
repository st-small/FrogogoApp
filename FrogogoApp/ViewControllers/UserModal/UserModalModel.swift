//
//  UserModalModel.swift
//  FrogogoApp
//
//  Created by Станислав Шияновский on 10/30/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public protocol UserModalModelProtocol: class {
    var user: User? { get }
}

public class UserModalModel: UserModalModelProtocol {
    
    // Data
    public var user: User?
    
    // Services
    private var networker: NetworkService
    private var fetcher: NetworkDataFetcher
    
    public init(_ user: User?) {
        self.user = user
        
        networker = NetworkService()
        fetcher = NetworkDataFetcher(networker)
    }
}
