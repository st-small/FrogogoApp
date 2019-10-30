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
    private var addButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Add")
        button.setImage(image, for: .normal)
        return button
    }()
    
    private var usersCollection = UsersCollectionView()
    
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
            
            viewModel.users.bind { [weak self] users in
                self?.usersWereUpdated(users: users)
            }
        }
    }
    
    // Services
    
    
    public override func loadView() {
        super.loadView()
        
        prepareNavigation()
        prepareCollectionView()
        prepareAddButton()
        
        viewModel?.getUsers()
    }
    
    private func prepareNavigation() {
        self.title = "Список пользователей"
    }
    
    private func prepareCollectionView() {
        view.addSubview(usersCollection)
        usersCollection.translatesAutoresizingMaskIntoConstraints = false
        usersCollection.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        usersCollection.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        usersCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        usersCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func prepareAddButton() {
        addButton.addTarget(self, action: #selector(addUser), for: .touchUpInside)
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    private func usersWereUpdated(users: [User]) {
        usersCollection.set(users: users)
        usersCollection.reloadData()
    }
    
    @objc private func addUser() {
    
    }
}
