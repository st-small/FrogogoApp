//
//  UserModalAssembly.swift
//  FrogogoApp
//
//  Created by Станислав Шияновский on 10/30/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public class UserModalAssembly {
    
    private var viewController: UserModalView?
    private var user: User?
    
    public var view: UserModalView {
        guard let view = viewController else {
            self.viewController = UserModalView()
            self.configureModule(self.viewController!)
            return self.viewController!
        }
        return view
    }
    
    public init(_ user: User? = nil) {
        self.user = user
    }
    
    private func configureModule(_ view: UserModalView) {
        view.viewModel = UserModalModel(user)
    }
}
