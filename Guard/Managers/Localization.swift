//
//  Localization.swift
//  Guard
//
//  Created by Idan Moshe on 11/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

enum Localization: String {
    
    enum SpecialCharacters {
        enum MiddlePoint: String {
            case small = "·"
            case large = "•"
        }
    }
    
    case language
    case accuracy
    case distance
    case today
    case yesterday
    case walking
    case running
    case driving
    case cycling
    case stationary
    case hours
    case hour
    case minutes
    case minute
    case seconds
    case second
    case authorized
    case noBackgroundAuthorization
    case notAuthorized
    case notYetConfigured
    case denied
    case provisional
    case morning
    case noon
    case afternoon
    case evening
    case night
    case dailyActivity
    case workout
    
    static var userPreferredLocalization: String {
        return Bundle.preferredLocalizations(from: ["he-IL", "en-US"]).first ?? Localization.language.english()
    }
    
    var preferredLocalization: String {
        if Localization.userPreferredLocalization == "he-IL" {
            return self.hebrew()
        } else {
            return self.english()
        }
    }
    
    static func semanticContentAttribute() -> UISemanticContentAttribute {
        if Localization.language.preferredLocalization == Localization.language.hebrew() {
            return UISemanticContentAttribute.forceRightToLeft
        } else {
            return UISemanticContentAttribute.forceLeftToRight
        }
    }
    
    func english() -> String {
        switch self {
        case .language: return "en-US"
        case .dailyActivity: return "Daily activity"
        case .notAuthorized: return "Not Authorized"
        default: return self.rawValue.capitalized
        }
    }
    
    func hebrew() -> String {
        switch self {
        case .language: return "he-IL"
        case .accuracy: return "דיוק"
        case .distance: return "מרחק"
        case .today: return "היום"
        case .yesterday: return "אתמול"
        case .walking: return "הליכה"
        case .running: return "ריצה"
        case .driving: return "נהיגה"
        case .cycling: return "רכיבה על אופניים"
        case .stationary: return "עמידה"
        case .hours: return "שעות"
        case .hour: return "שעה"
        case .minutes: return "דקות"
        case .minute: return "דקה"
        case .seconds: return "שניות"
        case .second: return "שניה"
        case .authorized: return "מורשה/יש אישור"
        case .noBackgroundAuthorization: return "אין אישור לפעילות ברקע"
        case .notAuthorized: return "לא מורשה"
        case .notYetConfigured: return "עדיין לא הוגדר" // Not yet defined
        case .denied: return "אין גישה/חסום"
        case .provisional: return "זמני"
        case .morning: return "בוקר"
        case .noon: return "צהריים"
        case .afternoon: return "אחרי הצהריים"
        case .evening: return "ערב"
        case .night: return "לילה"
        case .dailyActivity: return "פעילות יום-יומית"
        case .workout: return "אימון"
        }
    }
    
}
