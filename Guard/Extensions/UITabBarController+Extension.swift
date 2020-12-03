//
//  UITabBarController+Extension.swift
//  Daily
//
//  Created by Idan Moshe on 30/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

extension UITabBarController {
    
    func makeTransparent() {
        self.tabBar.barTintColor = .clear
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
    }
    
}
