//
//  UsersListAssembly.swift
//  FrogogoApp
//
//  Created by Станислав Шияновский on 10/30/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import Foundation

public class UsersListAssembly {
    
    private var viewController: UsersListView?
    
    public var view: UsersListView {
        guard let view = viewController else {
            self.viewController = UsersListView()
            self.configureModule(self.viewController!)
            return self.viewController!
        }
        return view
    }
    
    private func configureModule(_ view: UsersListView) {
        view.viewModel = UsersListModel()
    }
}
