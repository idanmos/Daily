//
//  PlacesViewModel.swift
//  Daily
//
//  Created by Idan Moshe on 28/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit

class PlacesViewModel {
    
    var startDate = Date.startOfToday() {
        didSet(newValue) {
            self.endDate = newValue.endOfDay()
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.startDateObserver(newValue.getTitle())
            }
            
        }
    }
    
    var endDate = Date().endOfDay()
    
    var places: [Any] = []
    
    private var startDateObserver: ((String) -> Void) = { arg in }
    
    deinit {
        self.places = []
        self.startDateObserver = { arg in }
    }
    
    func registerStartDateObserver(completionHandler: @escaping (String) -> Void) {
        self.startDateObserver = completionHandler
        completionHandler(self.startDate.getTitle())
    }
    
    func fetchVisitsAndLocations() {
        let filteredPlaces: [Any] = CoreDataController.fetchVisitsAndLocations(fetchLimit: 50).filter { (obj: Any) -> Bool in
            if obj is Visit {
                if let date: Date = (obj as! Visit).arrivalDate {
                    return Calendar.current.isDate(date, inSameDayAs: self.startDate)
                }
            } else if obj is Location {
                if let date: Date = (obj as! Location).timestamp {
                    return Calendar.current.isDate(date, inSameDayAs: self.startDate)
                }
            }
            return true
        }
        self.places = filteredPlaces
    }
    
}
