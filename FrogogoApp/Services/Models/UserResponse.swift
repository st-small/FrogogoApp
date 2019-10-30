//
//  UserResponse.swift
//  FrogogoApp
//
//  Created by Станислав Шияновский on 10/30/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public struct User: Decodable {
    public var id: Int
    public var firstName: String
    public var lastName: String
    public var email: String
    public var avatarUrl: String?
    public var url: String
}
