//
//  UIImage+Extension.swift
//  Guard
//
//  Created by Idan Moshe on 22/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

extension UIImage {
    
    static func house() -> UIImage? {
        return UIImage.systemImage("house", fill: false, size: .medium)
    }
    
    static func figureStand() -> UIImage? {
        return UIImage.systemImage("figure.stand", fill: false, size: .medium)
    }
    
    static func figureWalk() -> UIImage? {
        return UIImage.systemImage("figure.walk", fill: false, size: .medium)
    }
    
    static func car() -> UIImage? {
        return UIImage.systemImage("car", fill: false, size: .medium)
    }
    
    static func bicycle() -> UIImage? {
        return UIImage.systemImage("bicycle", fill: false, size: .medium)
    }
    
    static func location() -> UIImage? {
        return UIImage.systemImage("location", fill: false, size: .medium)
    }
    
    static func systemImage(_ name: String, fill: Bool? = false, size: UIImage.SymbolScale = .medium) -> UIImage? {
        let configuration = UIImage.SymbolConfiguration(scale: size)
        
        var fullName: String = name
        if let fill = fill, fill == true {
            fullName += ".fill"
        }
                
        return UIImage(systemName: name, withConfiguration: configuration)
    }
    
}
