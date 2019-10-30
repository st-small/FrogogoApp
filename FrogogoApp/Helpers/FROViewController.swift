//
//  FROViewController.swift
//  FrogogoApp
//
//  Created by Станислав Шияновский on 10/30/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

public class FROViewController: UIViewController {
    
    // UI elements
    private var blurView = UIView(frame: UIScreen.main.bounds)
    private var gradient: GradientView = {
        let start = Constants.Colors.MainGradient.start
        let end = Constants.Colors.MainGradient.end
        let view = GradientView(startColor: start, endColor: end)
        return view
    }()
    
    public override func loadView() {
        super.loadView()
        
        prepareBackground()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func prepareBackground() {
        view.addSubview(gradient)
        gradient.translatesAutoresizingMaskIntoConstraints = false
        gradient.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gradient.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        gradient.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        gradient.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    public func lockUI() {
        setupContainer()
        view.isUserInteractionEnabled = false
    }
    
    public func unlockUI() {
        view.isUserInteractionEnabled = true
        blurView.removeFromSuperview()
    }
    
    private func setupContainer() {
        blurView.backgroundColor = UIColor.white.withAlphaComponent(0.45)
        view.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.setNeedsLayout()
        guard blurView.subviews.isEmpty else { return }
        
        let lockViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 80.0, height: 80.0))
        lockViewContainer.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        lockViewContainer.layer.cornerRadius = 10.0
        lockViewContainer.clipsToBounds = true
        blurView.addSubview(lockViewContainer)
        lockViewContainer.center = blurView.center
        
        let activity = UIActivityIndicatorView(style: .whiteLarge)
        activity.color = .gray
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.startAnimating()
        lockViewContainer.addSubview(activity)
        activity.centerXAnchor.constraint(equalTo: lockViewContainer.centerXAnchor).isActive = true
        activity.centerYAnchor.constraint(equalTo: lockViewContainer.centerYAnchor).isActive = true
    }
    
    public func showErrorAlert(_ message: String) {
        let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title : "Ok", style : .default, handler: { action in
            self.okButtonTapped()
        })
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    public func okButtonTapped() { }
}
