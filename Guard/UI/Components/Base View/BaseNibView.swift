//
//  BaseNibView.swift
//  Guard
//
//  Created by Idan Moshe on 24/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class View: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadFromNib()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadFromNib()
    }
    
}
