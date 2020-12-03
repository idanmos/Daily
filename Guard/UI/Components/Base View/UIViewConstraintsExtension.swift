//
//  UIViewExtension.swift
//  CustomView
//
//  Created by Idan Moshe on 18/8/19.
//  Copyright (c) 2019 Idan Moshe. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: - constraints
    
    func addSubviewWithSameSizeConstraints(_ subview: UIView) {
        /*
        by default, the autoresizing mask on a view gives rise to constraints that fully determine the view's position.
        Any constraints you set on the view are likely to conflict with autoresizing constraints,
        so you must turn off this property first. IB will turn it off for you.
        */
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(subview);
        
        addSameSizeConstraints(subview)
    }
    
    func addSubviewWithSameSizeConstraints(_ subview: UIView, topView: UIView?) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(subview);
        
        addSameSizeConstraints(subview, topView: topView)
    }
    
    func insertSubviewWithSameSizeConstraints(_ subview: UIView, atIndex index:Int) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        insertSubview(subview, at: index)
        
        addSameSizeConstraints(subview)
    }
    
    func addSameSizeConstraints(_ subview: UIView) {
        
        addSameSizeConstraints(subview, topView: nil)
    }
    
    func addSubViewWithCenterConstraints(_ subview: UIView) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(subview)
        
        let padding: CGFloat = 0.0
        
        let centerConstraints = [
            NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: subview, attribute: .centerX, multiplier: 1.0, constant: padding),
            NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: subview, attribute: .centerY, multiplier: 1.0, constant: padding),
        ]
        addConstraints(centerConstraints)
    }
    
    fileprivate func addSameSizeConstraints(_ subview: UIView, topView: UIView?) {
        let padding: CGFloat = 0.0
        
        var topConstraint: NSLayoutConstraint!
        if topView == nil {
            // subview top is connected to view top
            topConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.top, multiplier: 1.0, constant: padding)
        } else {
            // subview top is connected to bottom of topView
            topConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.top, relatedBy: NSLayoutConstraint.Relation.equal, toItem: topView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: padding)
        }
        
        let bottomConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: padding)
        
        let rightConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: padding)
        
        let leftConstraint = NSLayoutConstraint(item: subview, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: padding)
        
        addConstraints([topConstraint, bottomConstraint, rightConstraint, leftConstraint])
    }
    
    func addSubviewWithSameWidthConstraints(_ subview: UIView, andheight height: CGFloat) {

        subview.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(subview);
        
        // vertical constraints to top + height
        let views = ["subview": subview]
        let metrics = ["height": height]
        let verticalConstraints   = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview(height)]", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: metrics, views: views)
        addConstraints(verticalConstraints)
        
        // horizontal constraints to right+left
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views)
        addConstraints(horizontalConstraints)
    }
    
    func addAdditionalActionButtonWithConstraints(_ button: UIButton) {
        let leadingConstant: CGFloat = 20.0
        let bottomConstant:  CGFloat = 10.0
        
        addOnScreenView(button, leadingConstant: leadingConstant, bottomConstant:  bottomConstant)
    }
    
    func addCaptureScreenWizardButtonWithConstraints(_ button: UIButton, smallMargins: Bool) {
        let leadingConstant: CGFloat = 15.0
        let bottomConstant:  CGFloat = smallMargins ? 15.0 : 85.0
        
        addOnScreenView(button, leadingConstant: leadingConstant, bottomConstant:  bottomConstant)
    }
    
    func addBotButtonWithConstraints(_ view: UIView, smallMargins: Bool) {
        let leadingConstant: CGFloat = 15.0
        let bottomConstant:  CGFloat = smallMargins ? 15.0 : 85.0
        
        addOnScreenView(view, leadingConstant: leadingConstant, bottomConstant:  bottomConstant)
    }
    
    func addOnScreenView(_ view: UIView, leadingConstant: CGFloat, bottomConstant:  CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(view)
        
        let leadingConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: leadingConstant)
        
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: bottomConstant)
        
        addConstraint(leadingConstraint)
        addConstraint(bottomConstraint)
    }
    
    fileprivate func addOnScreenImageView(_ imageView: UIImageView, leadingConstant: CGFloat, bottomConstant:  CGFloat) {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(imageView)
        
        let leadingConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.leading, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.leading, multiplier: 1.0, constant: leadingConstant)
        
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: NSLayoutConstraint.Attribute.bottom, relatedBy: NSLayoutConstraint.Relation.equal, toItem: imageView, attribute: NSLayoutConstraint.Attribute.bottom, multiplier: 1.0, constant: bottomConstant)
        
        addConstraint(leadingConstraint)
        addConstraint(bottomConstraint)
    }
    
//    func addSeperators() {
//        addBottomSeperator()
//        addTopSeperator()
//    }
//    
//    func addBottomSeperator() {
//        let seperator = UIView(frame: CGRectMake(0, self.bounds.height - 0.5, self.bounds.width, 0.5))
//        seperator.backgroundColor = UIColor.discountColorW5()
//        addSubview(seperator)
//    }
//    
//    func addTopSeperator() {
//        let seperator = UIView(frame: CGRectMake(0, 0, self.bounds.width, 0.5))
//        seperator.backgroundColor = UIColor.discountColorW5()
//        addSubview(seperator)
//    }
    
    func addBottomSeperatorWithHeight(_ height: CGFloat) {
        addSeparatorLineWithHeight(height, toTop: false)
    }
    
    func addTopSeperatorWithHeight(_ height: CGFloat) {
        addSeparatorLineWithHeight(height, toTop: true)
    }

    fileprivate func addSeparatorLineWithHeight(_ height: CGFloat, toTop: Bool) {
        let padding: CGFloat = 0.0
        
        let seperator = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        
        seperator.translatesAutoresizingMaskIntoConstraints = false
        
        var constraints = [NSLayoutConstraint]()
        
        let rightConstraint = NSLayoutConstraint(item: seperator, attribute: NSLayoutConstraint.Attribute.right, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.right, multiplier: 1.0, constant: padding)
        constraints.append(rightConstraint)
        
        let leftConstraint = NSLayoutConstraint(item: seperator, attribute: NSLayoutConstraint.Attribute.left, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: NSLayoutConstraint.Attribute.left, multiplier: 1.0, constant: padding)
        constraints.append(leftConstraint)
        
        let heightConstraint = NSLayoutConstraint(
            item: seperator,
            attribute: NSLayoutConstraint.Attribute.height,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1,
            constant: height
        )
        constraints.append(heightConstraint)
        
        let topOrBottomAttribute = toTop ? NSLayoutConstraint.Attribute.top : NSLayoutConstraint.Attribute.bottom
        
        let topOrBottomConstraint = NSLayoutConstraint(item: seperator, attribute: topOrBottomAttribute, relatedBy: NSLayoutConstraint.Relation.equal, toItem: self, attribute: topOrBottomAttribute, multiplier: 1.0, constant: padding)
        constraints.append(topOrBottomConstraint)
    
        addSubview(seperator)
        
        addConstraints(constraints)
    }
    
    func addWidthConstraintForMultilineLabel(widthConstant width: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false

        let widthConstraint = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutConstraint.Attribute.width,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1,
            constant: width
        )
        
        addConstraint(widthConstraint)
    }
}
