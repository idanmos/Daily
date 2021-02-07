//
//  LocationTableViewCell.swift
//  Guard
//
//  Created by Idan Moshe on 01/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit
import CoreLocation.CLLocation

class LocationTableViewCell: UITableViewCell {
    
    static let identifier: String = "LocationTableViewCell"
    
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var accuracyLabel: UILabel!
    @IBOutlet private weak var batteryLevelLabel: UILabel!
    @IBOutlet private weak var typeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.timeLabel.text = nil
        self.locationLabel.text = nil
        self.durationLabel.text = nil
        self.accuracyLabel.text = nil
        self.batteryLevelLabel.text = nil
    }
    
    func configure(_ location: Location) {
        self.timeLabel.text = nil
        self.locationLabel.text = nil
        self.durationLabel.text = nil
        self.accuracyLabel.text = nil
        self.batteryLevelLabel.text = nil
        
        self.typeImageView.image = UIImage.location()
        
        let batteryLevel = Int(location.batteryLevel * 100)
        self.batteryLevelLabel.text = "\(batteryLevel)%"
        
        if location.horizontalAccuracy > 0 {
            self.accuracyLabel.text = MapUtils.formatDistance(distance: location.horizontalAccuracy)
        }
        
        if let address: String = PersistentStorage.getAddress(from: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
            self.locationLabel.text = address
        } else {
            self.locationLabel.text = "\(location.latitude), \(location.longitude)"
        }
        
        if location.speed > 0 {
            self.durationLabel.text = "\(location.speed*Application.metersPerSecondToKmPerHour) kilometer per hour"
        }
        
        if let timestamp = location.timestamp {
            self.timeLabel.text = DateFormatter.timeOnly.string(from: timestamp)
        }
    }
    
    func configure(_ visit: Visit) {
        self.timeLabel.text = nil
        self.locationLabel.text = nil
        self.durationLabel.text = nil
        self.accuracyLabel.text = nil
        self.batteryLevelLabel.text = nil
        
        self.typeImageView.image = UIImage.house()
        
        let batteryLevel = Int(visit.batteryLevel * 100)
        self.batteryLevelLabel.text = "\(batteryLevel)%"
        
        if visit.horizontalAccuracy > 0 {
            self.accuracyLabel.text = MapUtils.formatDistance(distance: visit.horizontalAccuracy)
        }
        
        if let address: String = PersistentStorage.getAddress(from: CLLocationCoordinate2D(latitude: visit.latitude, longitude: visit.longitude)) {
            self.locationLabel.text = address
        } else {
            self.locationLabel.text = "\(visit.latitude), \(visit.longitude)"
        }
        
        guard let startDate = visit.arrivalDate else { return }
        guard let endDate = visit.departureDate else { return }
        
        if startDate == Date.distantPast {
            debugPrint("No start date")
        } else if endDate == Date.distantFuture {
            debugPrint("No end date")
        } else {
            if endDate.timeIntervalSince(startDate) > 0 {
                if let formattedDuration: String = UniversalConverter.timeDurationFormatter.string(from: startDate, to: endDate) {
                    self.durationLabel.text = formattedDuration
                }
            }
        }
                
        self.timeLabel.text = DateFormatter.timeOnly.string(from: startDate)
    }
    
}
