//
//  SleepAnalysisTableViewCell.swift
//  Guard
//
//  Created by Idan Moshe on 06/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class SleepAnalysisTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    static let identifier: String = "SleepAnalysisTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.timeLabel.text = ""
        self.activityLabel.text = ""
        self.durationLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateWithActivity(_ sleep: SleepData) {
        self.timeLabel.text = DateFormatter.timeOnly.string(from: sleep.startDate)
        self.activityLabel.text = sleep.avtivityDescription
        self.durationLabel.text = ""
        
        if sleep.endDate.timeIntervalSince(sleep.startDate) > 0 {
            if let formattedDuration: String = UniversalConverter.timeDurationFormatter.string(from: sleep.startDate, to: sleep.endDate) {
                self.durationLabel.text = formattedDuration
            }
        }
    }
    
}
