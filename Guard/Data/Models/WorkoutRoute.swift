//
//  WorkoutRoute.swift
//  Guard
//
//  Created by Idan Moshe on 08/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import Foundation
import HealthKit

class WorkoutRoute: NSObject {
        
    var workoutRoute: HKWorkoutRoute
    
    init(workoutRoute: HKWorkoutRoute) {
        self.workoutRoute = workoutRoute
    }
    
    override var description: String {
        return self.workoutRoute.description
    }
    
    func startDate() -> Date {
        return self.workoutRoute.startDate
    }
    
    func endDate() -> Date {
        return self.workoutRoute.endDate
    }
    
    // Example: ה-Apple Watch של Idan
    func source() -> String {
        return self.workoutRoute.sourceRevision.source.name
    }
    
    // Example: Apple Watch
    func device() -> String? {
        if let device: HKDevice = self.workoutRoute.device, let name = device.name {
            return name
        }
        return nil
    }
    
    // Example: Watch5,2
    func productType() -> String? {
        return self.workoutRoute.sourceRevision.productType
    }
    
    func uuid() -> UUID {
        return self.workoutRoute.uuid
    }
    
}
