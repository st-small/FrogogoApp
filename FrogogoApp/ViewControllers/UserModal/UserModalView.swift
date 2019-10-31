//
//  UserModalView.swift
//  FrogogoApp
//
//  Created by Станислав Шияновский on 10/30/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class UserModalView: FROViewController {
    
    // UI elements
    private var scroll: UIScrollView = {
        let scroll = UIScrollView()
        let size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scroll.contentSize = size
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
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
        field.borderStyle = .roundedRect
        field.placeholder = "Your name..."
        field.autocorrectionType = .no
        return field
    }()
    
    private let lastNameTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Your last name..."
        field.autocorrectionType = .no
        return field
    }()
    
    private let emailTextField: UITextField = {
        let field = UITextField()
        field.borderStyle = .roundedRect
        field.placeholder = "Your email..."
        field.autocorrectionType = .no
        return field
    }()
    
    private var updateButton: UIButton = {
        let button = UIButton(type: .roundedRect)
        button.isEnabled = false
        let color = Constants.Colors.MainGradient.end
        let disabledColor = color.withAlphaComponent(0.3)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = color.cgColor
        button.layer.cornerRadius = 22
        button.setTitleColor(color, for: .normal)
        button.setTitleColor(disabledColor, for: .disabled)
        return button
    }()
    
    private var closeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Close")
        button.setImage(image, for: .normal)
        return button
    }()
    
    // Data
    public var viewModel: UserModalModelProtocol! {
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
            
            viewModel.success.bind { [weak self] message in
                DispatchQueue.main.async {
                    self?.showSuccessAlert(message)
                }
            }
            
            viewModel.invalidFields.bind { [weak self] fields in
                for field in fields {
                    switch field {
                    case .firstName: self?.nameTextField.shake()
                    case .lastName: self?.lastNameTextField.shake()
                    case .email: self?.emailTextField.shake()
                    }
                }
            }
            
            viewModel.valuesUpdated.bind { [weak self] state in
                DispatchQueue.main.async {
                    self?.updateButton.isEnabled = state
                }
            }
        }
    }
    
    // Services
    private let notificationCenter = NotificationCenter.default
    
    public override func loadView() {
        needGradientBackground = false
        super.loadView()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        prepareScrollView()
        prepareContainer()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeTapped))
        tap.delegate = self
        view.addGestureRecognizer(tap)
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        let screenHeight = UIScreen.main.bounds.height
        let emptyFieldBelowContainer = screenHeight - container.frame.height
        let offset = keyboardViewEndFrame.height - emptyFieldBelowContainer/2 + 20
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            scroll.contentInset = UIEdgeInsets.zero
        } else {
            scroll.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: offset, right: 0)
        }
    }
    
    private func prepareScrollView() {
        view.addSubview(scroll)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scroll.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scroll.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scroll.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    private func prepareContainer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        container.addGestureRecognizer(tap)
        
        scroll.addSubview(container)
        container.isUserInteractionEnabled = true
        container.translatesAutoresizingMaskIntoConstraints = false
        
        container.centerXAnchor.constraint(equalTo: scroll.centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: scroll.centerYAnchor).isActive = true
        container.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        container.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        container.layer.cornerRadius = 10.0
        container.layer.masksToBounds = true
        
        prepareTitle()
        prepareNameTextField()
        prepareLastNameTextField()
        prepareEmailTextField()
        prepareUpdateButton()
        prepareCloseButton()
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
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        container.addSubview(nameTextField)
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40).isActive = true
        nameTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        
        guard let user = viewModel?.user else { return }
        nameTextField.text = user.firstName
    }
    
    private func prepareLastNameTextField() {
        lastNameTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        container.addSubview(lastNameTextField)
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        lastNameTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 20).isActive = true
        lastNameTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        lastNameTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        
        guard let user = viewModel?.user else { return }
        lastNameTextField.text = user.lastName
    }
    
    private func prepareEmailTextField() {
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        container.addSubview(emailTextField)
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 20).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor).isActive = true
        
        guard let user = viewModel?.user else { return }
        emailTextField.text = user.email
    }
    
    private func prepareUpdateButton() {
        updateButton.addTarget(self, action: #selector(updateTapped), for: .touchUpInside)
        container.addSubview(updateButton)
        updateButton.translatesAutoresizingMaskIntoConstraints = false
        
        updateButton.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        updateButton.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30).isActive = true
        updateButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        updateButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        var text = ""
        if let _ = viewModel?.user {
            text = "Update profile"
        } else {
            text = "Save new user"
        }
        updateButton.setTitle(text, for: .normal)
    }
    
    private func prepareCloseButton() {
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        container.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        
        closeButton.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -30).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 44).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func textFieldDidChange(textField: UITextField) {
        let user = UserModel(name: nameTextField.text ?? "",
                             lastName: lastNameTextField.text ?? "",
                             email: emailTextField.text ?? "")
        viewModel?.checkUsersValuesState(user: user)
    }
    
    @objc private func closeTapped() {
        closeKeyboard()
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func updateTapped() {
        let user = UserModel(name: nameTextField.text ?? "",
                             lastName: lastNameTextField.text ?? "",
                             email: emailTextField.text ?? "")
        viewModel?.update(user: user)
    }
    
    public override func okSuccessButtonTapped() {
        closeTapped()
    }
}

extension UserModalView: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view != container
    }
}
