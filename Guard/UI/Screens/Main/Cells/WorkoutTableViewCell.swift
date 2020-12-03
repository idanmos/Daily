//
//  WorkoutTableViewCell.swift
//  Guard
//
//  Created by Idan Moshe on 16/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class WorkoutTableViewCell: UITableViewCell {
    
    static let identifier: String = "WorkoutTableViewCell"
        
        @IBOutlet private weak var activityImageView: UIImageView!
        @IBOutlet private weak var timeLabel: UILabel!
        @IBOutlet private weak var activityTypeLabel: UILabel!
        @IBOutlet private weak var durationLabel: UILabel!
        @IBOutlet private weak var distanceLabel: UILabel!
    //    @IBOutlet private weak var stepsCountLabel: UILabel!
        
        override func awakeFromNib() {
            super.awakeFromNib()
        }

        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)

            // Configure the view for the selected state
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            
            self.activityTypeLabel.text = ""
            self.timeLabel.text = ""
            self.distanceLabel.text = ""
    //        self.stepsCountLabel.text = ""
            self.durationLabel.text = ""
        }
        
        func updateWithActivity(_ activity: Workout) {
            self.timeLabel.text = ""
            self.distanceLabel.text = ""
            self.durationLabel.text = ""
            
            let partOfTheDay: Application.PartsOfTheDay = Application.PartsOfTheDay.partOfTheDay(date: activity.startDate)
            self.activityTypeLabel.text = "\(Localization.workout.preferredLocalization) \(Localization.SpecialCharacters.MiddlePoint.large.rawValue) \(partOfTheDay.localized)"
            
            self.timeLabel.text = DateFormatter.timeOnly.string(from: activity.startDate)
            
            if activity.totalDistanceFormatted > 0.0 {
                self.distanceLabel.text = MapUtils.formatDistance(distance: activity.totalDistanceFormatted)
            }
            
            self.durationLabel.text = UniversalConverter.timeDurationFormatter.string(from: activity.startDate, to: activity.endDate)
        }
    
}
