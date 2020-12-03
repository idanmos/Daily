//
//  BaseTableViewController.swift
//  Guard
//
//  Created by Idan Moshe on 08/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.makeTransparent()
        self.tableView.hideFooterView()
    }

}
