//
//  UserModalView.swift
//  FrogogoApp
//
//  Created by Станислав Шияновский on 10/30/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class UserModalView: UIViewController {
    
    // UI elements
    private var container: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private let nameTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = UITextField.BorderStyle.roundedRect
        field.placeholder = "Your name..."
        return field
    }()
    
    // Data
    public var viewModel: UserModalModelProtocol! {
        didSet {
            
        }
    }
    
    // Services
    
    
    public override func loadView() {
        super.loadView()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        prepareContainer()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(close))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    private func prepareContainer() {
        view.addSubview(container)
        container.isUserInteractionEnabled = true
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        container.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true
        
        container.layer.cornerRadius = 10.0
        container.layer.masksToBounds = true
        
        prepareTitle()
        prepareNameTextField()
    }
    
    private func prepareTitle() {
        container.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 40).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 40).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -40).isActive = true
        
        var text = ""
        if let _ = viewModel?.user {
            text = "Edit user's profile"
        } else {
            text = "Add new user"
        }
        
        titleLabel.attributedText = NSAttributedString().prepareAttributedTextForTitleLabel(text)
        
    }
    
    private func prepareNameTextField() {
        container.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
}

extension UserModalView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view != container
    }
}
