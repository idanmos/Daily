//
//  UINavigationController+Extensions.swift
//  Guard
//
//  Created by Idan Moshe on 22/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    /// SwifterSwift: Make navigation controller's navigation bar transparent.
    ///
    /// - Parameter tint: tint color (default is .white).
    func makeTransparent(withTint tint: UIColor? = nil) {
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = true
        
        if let _ = tint {
            navigationBar.tintColor = tint!
            navigationBar.titleTextAttributes = [.foregroundColor: tint!]
        }
    }
    
}
