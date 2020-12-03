//
//  ShortActivitySummaryView.swift
//  Guard
//
//  Created by Idan Moshe on 14/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class ShortActivitySummaryView: StoryboardCustomXibView {
    
    @IBOutlet weak var firstTitleLabel: UILabel!
    @IBOutlet weak var firstSubtitleLabel: UILabel!
    
    @IBOutlet weak var secondTitleLabel: UILabel!
    @IBOutlet weak var secondSubtitleLabel: UILabel!
    
    @IBOutlet weak var thirdTitleLabel: UILabel!
    @IBOutlet weak var thirdSubtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.firstTitleLabel.text = ""
        self.firstSubtitleLabel.text = ""
        
        self.secondTitleLabel.text = ""
        self.secondSubtitleLabel.text = ""
        
        self.thirdTitleLabel.text = ""
        self.thirdSubtitleLabel.text = ""
    }
    
}
