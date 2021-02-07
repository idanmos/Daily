//
//  UIViewController+Extensions.swift
//  Guard
//
//  Created by Idan Moshe on 24/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

extension UIViewController {

    func viewFromNib() -> UIView {
        let name = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        guard let view = bundle.loadNibNamed(name, owner: self, options: nil)?.first as? UIView else {
            fatalError("Nib not found.")
        }
        return view
    }
    
    func openShareViewController(activityItems: [Any], completionWithItemsHandler: @escaping UIActivityViewController.CompletionWithItemsHandler) {
        let activityController = UIActivityViewController(activityItems: activityItems, applicationActivities: [])
        activityController.completionWithItemsHandler = completionWithItemsHandler
        self.present(activityController, animated: true, completion: nil)
    }
  
}
