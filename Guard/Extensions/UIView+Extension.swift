//
//  UIView+Extension.swift
//  Guard
//
//  Created by Idan Moshe on 06/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

extension UIView {
    
    func makeRoundButton() {
        self.layer.cornerRadius = self.frame.width/16
        self.layer.masksToBounds = true
    }
    
    func makeRounded() {
        self.layer.cornerRadius = self.frame.width/8
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.masksToBounds = true
    }
    
    func makeCircle() {
        self.layer.cornerRadius = self.frame.width/2
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.masksToBounds = true
    }
    
    func setGradientBackground(firstColor: UIColor, secondColor: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor, secondColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.bounds
                
        self.layer.insertSublayer(gradientLayer, at:0)
    }
    
    /// SwifterSwift: Take screenshot of view (if applicable).
        var screenshot: UIImage? {
            UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, 0)
            defer {
                UIGraphicsEndImageContext()
            }
            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            layer.render(in: context)
            return UIGraphicsGetImageFromCurrentImageContext()
        }
    
}

// MARK: - Load view from nib

extension UIView {

    func loadFromNib() {
        let name = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        guard let view = bundle.loadNibNamed(name, owner: self, options: nil)?.first as? UIView else {
            fatalError("Nib not found.")
        }
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        layoutAttachViewToSuperview(view: view)
    }

    func layoutAttachViewToSuperview(view: UIView) {
        let views = ["view" : view]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: views)
        addConstraints(horizontalConstraints + verticalConstraints)
    }

}
