//
//  UsersListModel.swift
//  FrogogoApp
//
//  Created by Станислав Шияновский on 10/30/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public protocol UsersListModelProtocol: class {
    var isUIBlocked: Dynamic<Bool> { get }
    var error: Dynamic<String> { get }
    
    func getUsers()
}

public class UsersListModel: UsersListModelProtocol {
    
    // Data
    public let isUIBlocked: Dynamic<Bool>
    public let error: Dynamic<String>

    // Services
    private var networker: NetworkService
    private var fetcher: NetworkDataFetcher
    
    public init() {
        isUIBlocked = Dynamic(false)
        error = Dynamic("")
        
        networker = NetworkService()
        fetcher = NetworkDataFetcher(networker)
    }
    
    public func getUsers() {
        fetcher.getUsers { (response) in
            
        }
    }
}
