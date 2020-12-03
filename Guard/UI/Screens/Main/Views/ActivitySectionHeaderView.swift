//
//  ActivitySectionHeaderView.swift
//  Guard
//
//  Created by Idan Moshe on 09/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class ActivitySectionHeaderView: StoryboardCustomXibView {
    
    @IBOutlet weak var stepsCountLabel: UILabel!
    @IBOutlet weak var caloriesBurnedLabel: UILabel!
        
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        super.awakeFromNib()
        self.stepsCountLabel.text = nil
        self.caloriesBurnedLabel.text = nil
    }
    
    func configureWithStartDate(_ startDate: Date) {
        self.stepsCountLabel.text = nil
        self.caloriesBurnedLabel.text = nil
        
        let steps: Double = HealthProfileDataStore.queryStepCount(startDate: startDate, endDate: startDate.endOfDay())
        self.stepsCountLabel.text = "\(Int(steps))"
        
        let activeEnergyBurned: Double = HealthProfileDataStore.queryActiveEnergyBurned(startDate: startDate, endDate: startDate.endOfDay())
        
        self.caloriesBurnedLabel.text = "\(Int(activeEnergyBurned))"
    }
    
}
