//
//  ActivityTableViewCell.swift
//  Guard
//
//  Created by Idan Moshe on 05/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    static let identifier: String = "ActivityTableViewCell"
    
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
    
    func updateWithActivity(_ activity: Activity) {
        self.activityTypeLabel.text = ""
        self.timeLabel.text = ""
        self.distanceLabel.text = ""
        self.durationLabel.text = ""
        
        if activity.activity.walking {
            self.activityImageView.image = UIImage.figureWalk()
        } else if activity.activity.running {
            self.activityImageView.image = UIImage(named: "stick_man_running")
        } else if activity.activity.cycling {
            self.activityImageView.image = UIImage.bicycle()
        } else if activity.activity.automotive {
            self.activityImageView.image = UIImage.car()
        }
        
        let partOfTheDay: Application.PartsOfTheDay = Application.PartsOfTheDay.partOfTheDay(date: activity.startDate)
        self.activityTypeLabel.text = "\(activity.activityType) \(Localization.SpecialCharacters.MiddlePoint.large.rawValue) \(partOfTheDay.localized)"
                
        self.timeLabel.text = "\(DateFormatter.timeOnly.string(from: activity.startDate)) \(Localization.SpecialCharacters.MiddlePoint.large.rawValue) \(Localization.dailyActivity.preferredLocalization)"
                
        if let numberOfSteps: Int = activity.numberOfSteps, numberOfSteps > 0 {
        }
        
        if let distanceInMeters: Int = activity.distance {
            self.distanceLabel.text = MapUtils.formatDistance(distance: Double(distanceInMeters))
        }
        
        if activity.startDate == Date.distantPast {
            // No start date
        } else if activity.endDate == Date.distantFuture {
            // No end date
        } else {
            self.durationLabel.text = UniversalConverter.timeDurationFormatter.string(from: activity.startDate, to: activity.endDate)
        }
    }
    
}
