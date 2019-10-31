//
//  UIView + Shake.swift
//  FrogogoApp
//
//  Created by Станислав Шияновский on 10/31/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

extension UIView {
    public func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-5.0, 5.0, -5.0, 5.0, -2.5, 2.5, -1.5, 1.5, 0.0 ]
        layer.add(animation, forKey: "shake")
    }
}
