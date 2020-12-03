//
//  StoryboardCustomXibView.swift
//  CustomView
//
//  Created by Idan Moshe on 18/8/19.
//  Copyright (c) 2019 Idan  Moshe. All rights reserved.
//

import UIKit

class StoryboardCustomXibView: UIControl {
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        if let customView = Bundle.main.loadNibNamed(xibName(), owner: self, options: nil)?.first as? UIView {
            backgroundColor = UIColor.clear
            customView.backgroundColor = backgroundColor
            addSubviewWithSameSizeConstraints(customView)
            awakeFromNib()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if let customView = Bundle.main.loadNibNamed(xibName(), owner: self, options: nil)?.first as? UIView {
            backgroundColor = UIColor.clear
            addSubviewWithSameSizeConstraints(customView)
        }
    }
    
    func xibName() -> String {
        return String(describing: type(of: self))
    }
}

class StoryboardCustomClearXibView: StoryboardCustomXibView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if let customChild = subviews.first {
            customChild.backgroundColor = UIColor.clear
        }
    }
    
    required init(frame: CGRect) {
       super.init(frame: frame)
    }
}
