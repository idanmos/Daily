//
//  BaseViewController.swift
//  Guard
//
//  Created by Idan Moshe on 09/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
                                
        self.navigationController?.makeTransparent()
    }

}
