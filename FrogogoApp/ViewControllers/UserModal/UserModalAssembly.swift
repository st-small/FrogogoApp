//
//  UserModalAssembly.swift
//  FrogogoApp
//
//  Created by Станислав Шияновский on 10/30/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public typealias ActionTrigger = (() -> ())

public class UserModalAssembly {
    
    public var handler: ActionTrigger?
    
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
        let model = UserModalModel(user, handler: handler)
        view.viewModel = model
    }
}
