//
//  UsersListView.swift
//  FrogogoApp
//
//  Created by Станислав Шияновский on 10/30/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class UsersListView: FROViewController {
    
    // UI elements
    
    
    // Data
    public var viewModel: UsersListModelProtocol! {
        didSet {
            viewModel.isUIBlocked.bind { [weak self] isBlocked in
                DispatchQueue.main.async {
                    isBlocked ? self?.lockUI() : self?.unlockUI()
                }
            }
            
            viewModel.error.bind { [weak self] error in
                DispatchQueue.main.async {
                    self?.showErrorAlert(error)
                }
            }
        }
    }
    
    // Services
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .red
        
        viewModel?.getUsers()
    }
}
