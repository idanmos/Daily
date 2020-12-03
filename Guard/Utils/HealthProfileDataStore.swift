//
//  HealthProfileDataStore.swift
//  Guard
//
//  Created by Idan Moshe on 06/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import HealthKit
import Foundation
import CoreLocation.CLLocation

class HealthProfileDataStore {
    
    private enum HealthkitSetupError: Error {
      case notAvailableOnDevice
      case dataTypeNotAvailable
    }
        
    static fileprivate let healthStore = HKHealthStore()
    
    // MARK: - Authorization
    
    class func authorizeHealthKit(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            DispatchQueue.main.async {
                completion(false, HealthkitSetupError.notAvailableOnDevice)
            }
            return
        }
        
//        let sleepAnalysis = Set([HKObjectType.categoryType(forIdentifier: .sleepAnalysis)]) as! Set<HKObjectType>
//        let step: HKQuantityType? = HKObjectType.quantityType(forIdentifier: .stepCount)
//        let walking: HKQuantityType? = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)
//        let cycling: HKQuantityType? = HKObjectType.quantityType(forIdentifier: .distanceCycling)
        
        guard   /* let dateOfBirth = HKObjectType.characteristicType(forIdentifier: .dateOfBirth), */
                /* let bloodType = HKObjectType.characteristicType(forIdentifier: .bloodType), */
                /* let biologicalSex = HKObjectType.characteristicType(forIdentifier: .biologicalSex), */
                /* let bodyMassIndex = HKObjectType.quantityType(forIdentifier: .bodyMassIndex), */
                /* let height = HKObjectType.quantityType(forIdentifier: .height), */
                /* let bodyMass = HKObjectType.quantityType(forIdentifier: .bodyMass), */
                let walking = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
                let cycling = HKObjectType.quantityType(forIdentifier: .distanceCycling),
                let steps = HKObjectType.quantityType(forIdentifier: .stepCount),
                let sleep = HKObjectType.categoryType(forIdentifier: .sleepAnalysis),
                let heartRate = HKObjectType.quantityType(forIdentifier: .heartRate),
                let activeEnergy = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)/* ,
                let basalEnergy = HKObjectType.quantityType(forIdentifier: .basalEnergyBurned) */ else {
                
                    DispatchQueue.main.async {
                        completion(false, HealthkitSetupError.dataTypeNotAvailable)
                    }
                return
        }
        
        /* let healthKitTypesToWrite: Set<HKSampleType> = [bodyMassIndex,
                                                        activeEnergy,
                                                        HKObjectType.workoutType()] */
            
        let healthKitTypesToRead: Set<HKObjectType> = [HKObjectType.workoutType(),
                                                       HKSeriesType.workoutRoute(),
                                                       walking,
                                                       cycling,
                                                       steps,
                                                       sleep,
                                                       activeEnergy,
                                                       heartRate]
                
        self.healthStore.requestAuthorization(toShare: Set(), read: healthKitTypesToRead) { (granted: Bool, error: Error?) in
            DispatchQueue.main.async {
                completion(granted, error)
            }
        }
    }
    
}

// MARK: - Steps Count

extension HealthProfileDataStore {
    
    // Sync
    class func queryStepCount(startDate: Date, endDate: Date) -> Double {
        var numberOfSteps: Double = 0
        
        let semaphore = DispatchSemaphore(value: 0)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let stepCount = HKObjectType.quantityType(forIdentifier: .stepCount)
        
        let query = HKStatisticsQuery(quantityType: stepCount!, quantitySamplePredicate: predicate, options: .cumulativeSum) { (statisticsQuery: HKStatisticsQuery, statistics: HKStatistics?, error: Error?) in
            if let error = error {
                semaphore.signal()
                return
            }
            
            if let statistics = statistics {
                if let quantity = statistics.sumQuantity() {
                    let steps: Double = quantity.doubleValue(for: HKUnit.count())
                    numberOfSteps = steps

                }
            }
            
            semaphore.signal()
        }
        
        self.healthStore.execute(query)
        
        semaphore.wait()
        
        return numberOfSteps
    }
    
    class func queryActiveEnergyBurned(startDate: Date, endDate: Date) -> Double {
        var numberOfSteps: Double = 0
        
        let semaphore = DispatchSemaphore(value: 0)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let stepCount = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)
        
        let query = HKStatisticsQuery(quantityType: stepCount!, quantitySamplePredicate: predicate, options: .cumulativeSum) { (statisticsQuery: HKStatisticsQuery, statistics: HKStatistics?, error: Error?) in
            if let error = error {
                semaphore.signal()
                return
            }
            
            if let statistics = statistics {
                if let quantity = statistics.sumQuantity() {
                    let steps: Double = quantity.doubleValue(for: HKUnit.kilocalorie())
                    numberOfSteps = steps

                }
            }
            
            semaphore.signal()
        }
        
        self.healthStore.execute(query)
        
        semaphore.wait()
        
        return numberOfSteps
    }
    
    class func queryAvarageHeartRate(startDate: Date, endDate: Date) -> Double {
        var heartRate: Double = 0
        
        let semaphore = DispatchSemaphore(value: 0)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let stepCount = HKObjectType.quantityType(forIdentifier: .heartRate)
        
        let query = HKStatisticsQuery(quantityType: stepCount!, quantitySamplePredicate: predicate, options: .discreteAverage) { (statisticsQuery: HKStatisticsQuery, statistics: HKStatistics?, error: Error?) in            
            if let _ = error {
                semaphore.signal()
                return
            }
            
            if let statistics = statistics {
                if let quantity = statistics.sumQuantity() {
                    let rate: Double = quantity.doubleValue(for: HKUnit.count())
                    heartRate = rate

                }
            }
            
            semaphore.signal()
        }
        
        self.healthStore.execute(query)
        
        semaphore.wait()
        
        return heartRate
    }
    
}

// MARK: - Sleep Analysis

extension HealthProfileDataStore {
    
    class func querySleepAnalysis(limit: Int, completionHandler: @escaping ([SleepData]) -> Void) {
        // first, we define the object type we want
        var sleepData: [SleepData] = []
        
        if let sleepType = HKObjectType.categoryType(forIdentifier: .sleepAnalysis) {
            
            // Use a sortDescriptor to get the recent data first
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            
            // we create our query with a block completion to execute
            let query = HKSampleQuery(sampleType: sleepType, predicate: nil, limit: limit, sortDescriptors: [sortDescriptor]) { (query: HKSampleQuery, results: [HKSample]?, error: Error?) -> Void in
                if let error = error {
                    Logger.shared.error("\(error)")
                    completionHandler([])
                    return
                }
                                
                if let results = results {
                    for item in results {
                        if let sample = item as? HKCategorySample {
                            if sample.value == HKCategoryValueSleepAnalysis.inBed.rawValue {
                                let obj = SleepData()
                                obj.isInBed = true
                                obj.startDate = sample.startDate
                                obj.endDate = sample.endDate
                                sleepData.append(obj)
                            } else if sample.value == HKCategoryValueSleepAnalysis.asleep.rawValue {
                                let obj = SleepData()
                                obj.isAsleep = true
                                obj.startDate = sample.startDate
                                obj.endDate = sample.endDate
                                sleepData.append(obj)
                            } else if sample.value == HKCategoryValueSleepAnalysis.awake.rawValue {
                                let obj = SleepData()
                                obj.isAwake = true
                                obj.startDate = sample.startDate
                                obj.endDate = sample.endDate
                                sleepData.append(obj)
                            }
                        }
                    }
                }
                
                completionHandler(sleepData)
            }
            
            // finally, we execute our query
            self.healthStore.execute(query)
        }
    }
    
}

// MARK: - Workout Routes

extension HealthProfileDataStore {
        
    class func queryWorkoutRoutes(startDate: Date,
                                  endDate: Date,
                                  completionHandler: @escaping ([WorkoutRoute]) -> Void) {
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKAnchoredObjectQuery(type: HKSeriesType.workoutRoute(), predicate: predicate, anchor: nil, limit: HKObjectQueryNoLimit) { (query: HKAnchoredObjectQuery, results: [HKSample]?, deletedObjects: [HKDeletedObject]?, anchor: HKQueryAnchor?, error: Error?) in
            if let _ = error {
                DispatchQueue.main.async {
                    completionHandler([])
                }
                return
            }
            
            guard let results = results, !results.isEmpty else {
                DispatchQueue.main.async {
                    completionHandler([])
                }
                return
            }
            
            var routes: [WorkoutRoute] = []
            
            for sample in results {
                if let route = sample as? HKWorkoutRoute {
                    routes.append(WorkoutRoute(workoutRoute: route))
                }
            }
            
            DispatchQueue.main.async {
                completionHandler(routes)
            }
        }
        
        self.healthStore.execute(query)
    }
    
    class func queryWorkoutRouteLocations(workoutRoute: WorkoutRoute, completionHandler: @escaping ([CLLocation]) -> Void) {
        let query = HKWorkoutRouteQuery(route: workoutRoute.workoutRoute) { (query, locationsOrNil, done, errorOrNil) in
            if let _ = errorOrNil {
                completionHandler([])
                return
            }
            
            guard let locations = locationsOrNil else {
                completionHandler([])
                return
            }
                                        
            if done {
                completionHandler(locations)
            }
        }
        self.healthStore.execute(query)
    }
    
}

// MARK: - Workouts

extension HealthProfileDataStore {
    
    class func queryWorkouts(startDate: Date, endDate: Date, completionHandler: @escaping ([Workout]) -> Void) {
        var workouts: [Workout] = []
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: .strictStartDate)
        
        let query = HKAnchoredObjectQuery(type: HKObjectType.workoutType(), predicate: predicate, anchor: nil, limit: HKObjectQueryNoLimit) { (query: HKAnchoredObjectQuery, results: [HKSample]?, deletedObjects: [HKDeletedObject]?, anchor: HKQueryAnchor?, error: Error?) in
            if let error = error {
                completionHandler([])
                return
            }
            
            guard let results = results, !results.isEmpty else {
                completionHandler([])
                return
            }
            
            for sample in results {
                if let workout = sample as? HKWorkout {
                    workouts.append(Workout(workout: workout))
                }
            }
            
            completionHandler(workouts)
        }
        
        self.healthStore.execute(query)
    }
    
}
