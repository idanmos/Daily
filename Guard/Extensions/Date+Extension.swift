//
//  Date+Extension.swift
//  Guard
//
//  Created by Idan Moshe on 05/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

extension Date {
    
    static func startOfToday() -> Date {
        return Calendar.current.startOfDay(for: Date())
    }
    
    static func now() -> Date {
        return Date()
    }
    
    func startOfDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }

    func endOfDay() -> Date {
        if Calendar.current.isDateInToday(self) {
            return Date.now()
        } else {
            let nextDayDate = Calendar.current.date(byAdding: .day, value: 1, to: self)!
            return nextDayDate.addingTimeInterval(-1)
        }
    }
    
    func getTitle() -> String {
        var title: String = ""
        if Calendar.current.isDateInToday(self) {
            title = Localization.today.preferredLocalization
        } else if Calendar.current.isDateInYesterday(self) {
            title = Localization.yesterday.preferredLocalization
        } else {
            title = DateFormatter.dateOnly.string(from: self)
        }
        return title
    }
    
}

extension DateFormatter {
    
    static let timeOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone.israelTimeZone
        formatter.locale = Locale.hebrewLocale
        formatter.calendar = Calendar.israelCalendar
        return formatter
    }()
    
    static let dateOnly: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.timeZone = TimeZone.israelTimeZone
        formatter.locale = Locale.hebrewLocale
        formatter.calendar = Calendar.israelCalendar
        return formatter
    }()
        
}

extension NumberFormatter {
    static let distanceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = true
        formatter.alwaysShowsDecimalSeparator = false
        formatter.maximumFractionDigits = 2
        return formatter
    }()
}

extension TimeZone {
    static var israelTimeZone: TimeZone {
        return TimeZone.current
//        return TimeZone(identifier: "Asia/Jerusalem")!
    }
}

extension Calendar {
    
    static var hebrewCalendar: Calendar {
        return Calendar.current
//        return Calendar(identifier: .hebrew)
    }
    
    static var israelCalendar: Calendar {
        var obj = Calendar(identifier: .gregorian)
        obj.timeZone = TimeZone.israelTimeZone
        obj.locale = Locale.hebrewLocale
        return obj
    }
    
    static var localCalendar: Calendar {
        var obj = Calendar.current
        obj.timeZone = .current
        obj.locale = .current
        return obj
    }
    
}

extension Locale {
    static var hebrewLocale: Locale {
        return Locale.current
//        return Locale(identifier: "he-IL")
    }
}
