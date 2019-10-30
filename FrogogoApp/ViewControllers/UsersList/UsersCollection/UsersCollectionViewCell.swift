//
//  UsersCollectionViewCell.swift
//  FrogogoApp
//
//  Created by Станислав Шияновский on 10/30/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class UsersCollectionViewCell: UICollectionViewCell {
    
    public static let reuseId = "UsersCollectionViewCell"
    
    private let myImageView: WebImageView = {
        let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = #colorLiteral(red: 0.8901960784, green: 0.8980392157, blue: 0.9098039216, alpha: 1)
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        label.textColor = #colorLiteral(red: 0.1728, green: 0.1764, blue: 0.18, alpha: 1)
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        
        prepareAvatarView()
        prepareNameLabel()
        prepareEmailLabel()
    }
    
    private func prepareAvatarView() {
        addSubview(myImageView)
        myImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        myImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        myImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        myImageView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        myImageView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        myImageView.layer.borderWidth = 1.0
        myImageView.layer.borderColor = Constants.Colors.MainGradient.end.cgColor
    }
    
    private func prepareNameLabel() {
        addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 14).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: myImageView.trailingAnchor, constant: 20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }
    
    private func prepareEmailLabel() {
        addSubview(emailLabel)
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        emailLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
        emailLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
    }
    
    public override func prepareForReuse() {
        myImageView.image = nil
    }
    
    public func set(user: User) {
        myImageView.set(imageURL: user.avatarUrl)
        nameLabel.text = user.name
        emailLabel.text = user.email
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        myImageView.layer.masksToBounds = true
        myImageView.layer.cornerRadius = 30
        
        layer.cornerRadius = 10.0
        layer.shadowRadius = 10.0
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 2.5, height: 4.0)
        
        clipsToBounds = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
