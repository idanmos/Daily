//
//  UINavigationBar+Extension.swift
//  Guard
//
//  Created by Idan Moshe on 07/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

extension UINavigationBar {

    func setBottomBorderColor(color: UIColor, height: CGFloat) {
        let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = color
        addSubview(bottomBorderView)
    }
    
    /// SwifterSwift: Set Navigation Bar title, title color and font.
        ///
        /// - Parameters:
        ///   - font: title font
        ///   - color: title text color (default is .black).
        func setTitleFont(_ font: UIFont, color: UIColor = .black) {
            var attrs = [NSAttributedString.Key: Any]()
            attrs[.font] = font
            attrs[.foregroundColor] = color
            titleTextAttributes = attrs
        }

        /// SwifterSwift: Make navigation bar transparent.
        ///
        /// - Parameter tint: tint color (default is .white).
        func makeTransparent(withTint tint: UIColor = .white) {
            isTranslucent = true
            backgroundColor = .clear
            barTintColor = .clear
            setBackgroundImage(UIImage(), for: .default)
            tintColor = tint
            titleTextAttributes = [.foregroundColor: tint]
            shadowImage = UIImage()
        }

        /// SwifterSwift: Set navigationBar background and text colors
        ///
        /// - Parameters:
        ///   - background: backgound color
        ///   - text: text color
        func setColors(background: UIColor, text: UIColor) {
            isTranslucent = false
            backgroundColor = background
            barTintColor = background
            setBackgroundImage(UIImage(), for: .default)
            tintColor = text
            titleTextAttributes = [.foregroundColor: text]
        }
        
}
