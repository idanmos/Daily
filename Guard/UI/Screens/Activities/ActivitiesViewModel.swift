//
//  ActivitiesViewModel.swift
//  Daily
//
//  Created by Idan Moshe on 29/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class ActivitiesViewModel {
    
    var activities: [Any] = []
    
    var startDate = Date().startOfDay()
    
    func fetchData(completionHandler: @escaping () -> Void) {
        self.activities.removeAll()
                
        let group = DispatchGroup()
        
        let queue = DispatchQueue(label: "com.idanmoshe.daily.fetchData",
                                  qos: .userInteractive,
                                  attributes: .concurrent,
                                  autoreleaseFrequency: .inherit,
                                  target: .main)
        
        // Daily Activities
        queue.async(group: group, execute: { [weak self] in
            group.enter()
            
            guard let self = self else {
                group.leave()
                return
            }
            
            if PreferenceManager.isActivityEnabled {
                self.fetchActivities { (obj: [Activity]) in
                    if obj.count > 0 {
                        self.activities.append(contentsOf: obj)
                    }
                    group.leave()
                }
            } else {
                group.leave()
            }
        })
        
        
        // Workouts
        queue.async(group: group, execute: { [weak self] in
            group.enter()
            
            guard let self = self else {
                group.leave()
                return
            }
            
            if PreferenceManager.isHealthEnabled {
                self.fetchWorkouts { (obj: [Workout]) in
                    if obj.count > 0 {
                        self.activities.append(contentsOf: obj)
                    }
                    group.leave()
                }
            } else {
                group.leave()
            }
        })
        
        
        // Sleep Analysis
        queue.async(group: group, execute: { [weak self] in
            group.enter()
            
            guard let self = self else {
                group.leave()
                return
            }
            
            self.fetchSleepAnalysis { (obj: [SleepData]) in
                if obj.count > 0 {
                    self.activities.append(contentsOf: obj)
                }
                group.leave()
            }
        })
                
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.sortData()
            
            completionHandler()
        }
    }
    
    private func fetchActivities(completionHandler: @escaping ([Activity]) -> Void) {
        MotionManager.shared.queryForRecentActivityData(startDate: self.startDate, endDate: self.startDate.endOfDay()) { [weak self] (activities: [Activity]) in
            guard let self = self else {
                completionHandler([])
                return
            }
            
            guard !activities.isEmpty else {
                debugPrint("No matching activities")
                completionHandler([])
                return
            }
                        
            let filteredActivities: [Activity] = activities.filter { (activity: Activity) -> Bool in
                return Calendar.current.isDate(activity.startDate, inSameDayAs: self.startDate)
            }
            
            completionHandler(filteredActivities)
        }
    }
    
    private func fetchWorkouts(completionHandler: @escaping ([Workout]) -> Void) {
        HealthProfileDataStore.queryWorkouts(startDate: self.startDate, endDate: self.startDate.endOfDay(), completionHandler: completionHandler)
    }
    
    private func fetchSleepAnalysis(completionHandler: @escaping ([SleepData]) -> Void) {
        HealthProfileDataStore.querySleepAnalysis(limit: 10) { [weak self] (sleepData: [SleepData]) in
            guard let self = self else {
                completionHandler([])
                return
            }
                        
            var sleepAnalysis: [SleepData] = []
            
            for obj: SleepData in sleepData {
                if Calendar.current.isDate(self.startDate, inSameDayAs: obj.startDate) {
                    // If start date is equal
                    sleepAnalysis.append(obj)
                } else if Calendar.current.isDate(self.startDate.endOfDay(), inSameDayAs: obj.endDate) {
                    // Is end date is equal
                    sleepAnalysis.append(obj)
                }
            }
            
            completionHandler(sleepAnalysis)
        }
    }
    
    private func sortData() {
        self.activities.sort { (obj1: Any, obj2: Any) -> Bool in
            var firstDate: Date!
            var secondDate: Date!
            
            if obj1 is Activity {
                firstDate = (obj1 as! Activity).startDate
            } else if obj1 is Workout {
                firstDate = (obj1 as! Workout).startDate
            } else if obj1 is SleepData {
                firstDate = (obj1 as! SleepData).startDate
            }
            
            if obj2 is Activity {
                secondDate = (obj2 as! Activity).startDate
            } else if obj2 is Workout {
                secondDate = (obj2 as! Workout).startDate
            } else if obj2 is SleepData {
                secondDate = (obj2 as! SleepData).startDate
            }
            
            return firstDate > secondDate
        }
    }
    
}
