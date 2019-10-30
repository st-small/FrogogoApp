//
//  UsersCollectionView.swift
//  FrogogoApp
//
//  Created by Станислав Шияновский on 10/30/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class UsersCollectionView: UICollectionView {
    
    // Data
    private var users = [User]()
    
    public init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 15
        super.init(frame: .zero, collectionViewLayout: layout)
        
        delegate = self
        dataSource = self
        
        backgroundColor = .clear
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        
        contentInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        
        register(UsersCollectionViewCell.self, forCellWithReuseIdentifier: UsersCollectionViewCell.reuseId)
    }
    
    public func set(users: [User]) {
        self.users = users
        contentOffset = .zero
        reloadData()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

extension UsersCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: UsersCollectionViewCell.reuseId, for: indexPath) as! UsersCollectionViewCell
        cell.set(user: users[indexPath.row])
        return cell
    }
}

extension UsersCollectionView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension UsersCollectionView: UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = UIScreen.main.bounds.width - 32
        return CGSize(width: width, height: 80)
    }
}
