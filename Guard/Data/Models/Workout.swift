//
//  Workout.swift
//  Guard
//
//  Created by Idan Moshe on 08/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import Foundation
import HealthKit

class Workout {
    
    var workout: HKWorkout
        
    init(workout: HKWorkout) {
        self.workout = workout
    }
    
    var startDate: Date {
        return self.workout.startDate
    }
    
    var endDate: Date {
        return self.workout.endDate
    }
    
    // Example: ה-Apple Watch של Idan
    var source: String {
        return self.workout.sourceRevision.source.name
    }
    
    // Example: Apple Watch
    var device: String? {
        if let device: HKDevice = self.workout.device, let name = device.name {
            return name
        }
        return nil
    }
    
    // Example: Watch5,2
    var productType: String? {
        return self.workout.sourceRevision.productType
    }
    
    var uuid: UUID {
        return self.workout.uuid
    }
    
    var totalDistanceFormatted: Double {
        if let totalDistance: HKQuantity = self.workout.totalDistance {
            return totalDistance.doubleValue(for: .meter())
        }
        return 0.0
    }
    
}
