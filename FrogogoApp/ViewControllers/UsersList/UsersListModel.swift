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
    var users: Dynamic<[User]> { get }
    
    func getUsers()
    func filterUser(by id: Int) -> User?
}

public class UsersListModel: UsersListModelProtocol {
    
    // Data
    public let isUIBlocked: Dynamic<Bool>
    public let error: Dynamic<String>
    public let users: Dynamic<[User]>

    // Services
    private var networker: NetworkService
    private var fetcher: NetworkDataFetcher
    
    public init() {
        isUIBlocked = Dynamic(false)
        error = Dynamic("")
        users = Dynamic([])
        
        networker = NetworkService()
        fetcher = NetworkDataFetcher(networker)
    }
    
    public func getUsers() {
        isUIBlocked.value = true
        fetcher.getUsers { [weak self] (response) in
            self?.isUIBlocked.value = false
            guard let users = response else { return }
            self?.users.value = users
        }
    }
    
    public func filterUser(by id: Int) -> User? {
        return users.value.filter({ $0.id == id }).first
    }
}
