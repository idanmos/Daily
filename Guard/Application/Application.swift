//
//  Application.swift
//  Guard
//
//  Created by Idan Moshe on 23/08/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class Application {
    
    enum Result<T> {
        case success(T)
        case failure(Error)
    }
    
    enum ActivityType {
        case unknown
        case stationary
        case walking
        case running
        case automotive
        case cycling
    }
    
    enum PartsOfTheDay: String {
        
        case morning
        case noon
        case afternoon
        case evening
        case night
        
        var localized: String {
            switch self {
            case .morning: return Localization.morning.preferredLocalization
            case .noon: return Localization.noon.preferredLocalization
            case .afternoon: return Localization.afternoon.preferredLocalization
            case .evening: return Localization.evening.preferredLocalization
            case .night: return Localization.night.preferredLocalization
            }
        }
        
        static func partOfTheDay(date: Date) -> PartsOfTheDay {
            let hour = Calendar.current.component(.hour, from: date)
            switch hour {
            case 6..<12 : return .morning
            case 12 : return .noon
            case 13..<17 : return .afternoon
            case 17..<22 : return .evening
            default: return .night
            }
        }
    }
    
    enum MapType {
        case visits
        case workouts
        case allDay
    }
    
    enum GoogleAdMob {
        static let appId: String = "ca-app-pub-6158225633661411~4108391542"
        static let bannerId: String = "ca-app-pub-6158225633661411/9312616764"
    }
    
    static let metersPerSecondToKmPerHour: Double = 3.6
    
}
