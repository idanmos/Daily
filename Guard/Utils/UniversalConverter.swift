//
//  UniversalConverter.swift
//  Guard
//
//  Created by Idan Moshe on 04/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import Foundation

class UniversalConverter {
        
    class func convertStepsToKilometer(_ steps: Int) -> Double {
        // 1 metre is equal to 1.3123359580052 steps
        return Double(steps/1320)
    }
        
    class func convertStepsToCaloriesBurned(_ steps: Int) -> Double {
        // # of steps*.04 = calories
        return Double(steps)*0.04
    }
    
    class func convertStepsToCaloriesBurned(_ steps: Int, BMI: Int, age: Int, speed: Double) -> Double {
        // Calories Burned = #steps * .04 * BF * AF * SF
        return Double(steps)*0.04*Double(BMI)*Double(age)*speed
    }
    
    class func calculateAverageWalkingSpeedByAge(_ age: Int) -> Double {
        // Meters per second
        switch age {
        case 20...29: return 1.34
        case 30...39: return 1.34
        case 40...49: return 1.39
        case 50...59: return 1.31
        case 60...69: return 1.24
        case 70...79: return 1.13
        case 80...89: return 0.94
        default: return 3.0
        }
    }
    
    class func calculateAverageWalkingSpeedByAge(_ age: Int, isMale: Bool) -> Double {
        // Meters per second
        switch age {
        case 20...29: return isMale ? 1.36 : 1.34
        case 30...39: return isMale ? 1.43 : 1.34
        case 40...49: return isMale ? 1.43 : 1.39
        case 50...59: return isMale ? 1.43 : 1.31
        case 60...69: return isMale ? 1.34 : 1.24
        case 70...79: return isMale ? 1.26 : 1.13
        case 80...89: return isMale ? 0.97 : 0.94
        default: return 3.0
        }
    }
    
    static var timeDurationFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.calendar = Calendar.israelCalendar
        formatter.unitsStyle = .short
        return formatter
    }()
    
}
