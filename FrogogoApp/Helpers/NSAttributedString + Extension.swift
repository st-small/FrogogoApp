//
//  NSAttributedString + Extension.swift
//  FrogogoApp
//
//  Created by Станислав Шияновский on 10/30/19.
//  Copyright © 2019 Станислав Шияновский. All rights reserved.
//

import UIKit

extension NSAttributedString {
    
    public func prepareAttributedTextForTitleLabel(_ text: String) -> NSAttributedString {
        let font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        let color = #colorLiteral(red: 0.1728, green: 0.1764, blue: 0.18, alpha: 1)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.alignment = .center
        
        let attributes: [NSAttributedString.Key: Any] =
            [.font: font,
             .strokeColor: color,
             .paragraphStyle: paragraphStyle]
        
        return NSAttributedString(string: text, attributes: attributes)
    }
}
