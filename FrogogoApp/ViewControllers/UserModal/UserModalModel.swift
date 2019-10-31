//
//  UserModalModel.swift
//  FrogogoApp
//
//  Created by Станислав Шияновский on 10/30/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public enum UserProfileFieldType {
    case firstName
    case lastName
    case email
}

public typealias UserModel = (name: String, lastName: String, email: String)

public protocol UserModalModelProtocol: class {
    var isUIBlocked: Dynamic<Bool> { get }
    var error: Dynamic<String> { get }
    var success: Dynamic<String> { get }
    var invalidFields: Dynamic<[UserProfileFieldType]> { get }
    var user: User? { get }
    var valuesUpdated: Dynamic<Bool> { get }
    
    func checkUsersValuesState(user: UserModel)
    func update(user: UserModel)
}

public class UserModalModel: UserModalModelProtocol {
    
    // Data
    public let isUIBlocked: Dynamic<Bool>
    public let error: Dynamic<String>
    public let success: Dynamic<String>
    public var invalidFields: Dynamic<[UserProfileFieldType]>
    public var user: User?
    public var valuesUpdated: Dynamic<Bool>
    
    public var handler: (() -> ())?
    
    // Services
    private var networker: NetworkService
    private var fetcher: NetworkDataFetcher
    
    public init(_ user: User?, handler: (() -> ())?) {
        self.isUIBlocked = Dynamic(false)
        self.error = Dynamic("")
        self.success = Dynamic("")
        self.invalidFields = Dynamic([])
        self.user = user
        self.valuesUpdated = Dynamic(false)
        self.handler = handler
        
        networker = NetworkService()
        fetcher = NetworkDataFetcher(networker)
    }
    
    public func update(user: UserModel) {
        var invalidFields: [UserProfileFieldType] = []
        
        if !validateName(user.name) { invalidFields.append(.firstName)}
        if !validateName(user.lastName) { invalidFields.append(.lastName)}
        if !validateEmail(user.email) { invalidFields.append(.email)}
        
        guard invalidFields.isEmpty else {
            self.invalidFields.value = invalidFields
            return
        }
        
        if self.user != nil {
            updateExistingUser(user)
        } else {
            addNewUser(user)
        }
    }
    
    public func checkUsersValuesState(user: UserModel) {
        if self.user == nil {
            let state = !user.name.isEmpty || !user.lastName.isEmpty || !user.email.isEmpty
            valuesUpdated.value = state
        } else {
            let state = user.name != self.user?.firstName || user.lastName != self.user?.lastName || user.email != self.user?.email
            valuesUpdated.value = state
        }
    }
    
    private func addNewUser(_ model: UserModel) {
        isUIBlocked.value = true
        fetcher.addUser(userModel: model) { [weak self] (success, error) in
            self?.isUIBlocked.value = false
            if let error = error {
                self?.error.value = error
                return
            }
            
            self?.success.value = "User was added successfully!"
            self?.handler?()
        }
    }
    
    private func updateExistingUser(_ model: UserModel) {
        guard let user = user else { return }
        isUIBlocked.value = true
        let updatedUser = User(id: user.id,
                               firstName: model.name,
                               lastName: model.lastName,
                               email: model.email,
                               avatarUrl: "")
        fetcher.updateUser(userModel: updatedUser) { [weak self] (success, error) in
            self?.isUIBlocked.value = false
            if let error = error {
                self?.error.value = error
                return
            }
            
            self?.success.value = "User was updated successfully!"
            self?.handler?()
        }
    }

    private func validateName(_ text: String) -> Bool {
        guard !text.isEmpty else { return false }
        return true
    }
    
    private func validateEmail(_ text: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: text)
    }
}
