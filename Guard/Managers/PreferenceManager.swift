//
//  PreferenceManager.swift
//  Guard
//
//  Created by Idan Moshe on 14/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import Foundation

class PreferenceManager {
    
    // MARK: - Properties(public)
    
    
    // MARK: - Properties(private)
    
    private static let defaults = UserDefaults.standard
    
    // MARK: - Tutorial
    
    enum Tutorial {
        static let isTutorialCompleted = "com.idanmoshe.guard.tutorialCompleted"
    }
    
    static var isTutorialCompleted: Bool {
        get {
            return defaults.bool(forKey: Tutorial.isTutorialCompleted)
        } set {
            defaults.set(newValue, forKey: Tutorial.isTutorialCompleted)
        }
    }
    
    // MARK: - Settings
    
    enum Settings {
        static let isVisitSwitchEnable = "com.idanmoshe.guard.isVisitSwitchEnable"
        static let isActivitySwitchEnable = "com.idanmoshe.guard.isActivitySwitchEnable"
        static let isHealthSwitchEnable = "com.idanmoshe.guard.isHealthSwitchEnable"
    }
    
    static var isVisitsEnabled: Bool {
        get {
            return defaults.bool(forKey: Settings.isVisitSwitchEnable)
        } set {
            defaults.set(newValue, forKey: Settings.isVisitSwitchEnable)
        }
    }
    
    static var isActivityEnabled: Bool {
        get {
            return defaults.bool(forKey: Settings.isActivitySwitchEnable)
        } set {
            defaults.set(newValue, forKey: Settings.isActivitySwitchEnable)
        }
    }
    
    static var isHealthEnabled: Bool {
        get {
            return defaults.bool(forKey: Settings.isHealthSwitchEnable)
        } set {
            defaults.set(newValue, forKey: Settings.isHealthSwitchEnable)
        }
    }
    
    // MARK: - Public Methods
    
    func getCurrentConfigurations(completionHandler: @escaping () -> Void) {}
    
    func reloadAllTimelines() {}
    
    func reloadTimelines(ofKind: Any) {}
    
}
