//
//  UITableView+Extension.swift
//  Daily
//
//  Created by Idan Moshe on 30/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

extension UITableView {
    
    func hideFooterView() {
        self.tableFooterView = UIView(frame: .zero)
    }
    
    func hideSeperator() {
        self.separatorStyle = .none
    }
    
}
