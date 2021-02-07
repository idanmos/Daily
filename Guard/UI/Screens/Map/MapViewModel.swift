//
//  MapViewModel.swift
//  Daily
//
//  Created by Idan Moshe on 29/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit
import MapKit

class MapViewModel {
    
    var places: [Any] = []
    var timestamp = Date.startOfToday()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        formatter.timeZone = .current
        formatter.calendar = .current
        return formatter
    }()
    
    deinit {
        self.places = []
    }
    
    func fetchVisitsAndLocations() {
        let filteredPlaces: [Any] = PersistentStorage.fetchVisitsAndLocations(fetchLimit: 50).filter { (obj: Any) -> Bool in
            if obj is Visit {
                if let date: Date = (obj as! Visit).arrivalDate {
                    return Calendar.current.isDate(date, inSameDayAs: self.timestamp)
                }
            } else if obj is Location {
                if let date: Date = (obj as! Location).timestamp {
                    return Calendar.current.isDate(date, inSameDayAs: self.timestamp)
                }
            }
            return true
        }
        self.places = filteredPlaces
        
        self.fetchWorkoutRoutes { (locations: [[CLLocation]]) in
            debugPrint(locations)
        }
    }
    
    func addAnnotations(mapView: MKMapView) {
        mapView.removeAnnotations(mapView.annotations)
        
        self.fetchVisitsAndLocations()
        
        let visits = self.places.filter { (obj: Any) -> Bool in
            return obj is Visit
        }
        
        let significantLocations = self.places.filter { (obj: Any) -> Bool in
            return obj is Location
        }
        
        for significantLocation: Location in (significantLocations as! [Location]) {
            let annotation = LocationAnnotation()
            annotation.title = "Place"
            annotation.subtitle = "\(self.dateFormatter.string(from: significantLocation.timestamp!))"
            
            if let address: String = PersistentStorage.getAddress(from: CLLocationCoordinate2D(latitude: significantLocation.latitude, longitude: significantLocation.longitude)) {
                annotation.title = address
            }
            
            annotation.coordinate = CLLocationCoordinate2DMake(significantLocation.latitude, significantLocation.longitude)
            mapView.addAnnotation(annotation)
        }
        
        for visit: Visit in (visits as! [Visit]) {
            if let arrivalDate = visit.arrivalDate {
                let annotation = VisitAnnotation()
                annotation.title = "Visit"
                
                annotation.subtitle = "\(self.dateFormatter.string(from: arrivalDate))"
                
                if let address: String = PersistentStorage.getAddress(from: CLLocationCoordinate2D(latitude: visit.latitude, longitude: visit.longitude)) {
                    annotation.title = address
                }
                
                if arrivalDate != Date.distantPast {
                    if let departureDate: Date = visit.departureDate {
                        let duration: TimeInterval = departureDate.timeIntervalSince(arrivalDate)
                        
                        if departureDate == Date.distantFuture || duration == 0 {
                            annotation.subtitle = "\(DateFormatter.timeOnly.string(from: arrivalDate))"
                        } else {
                            if duration > 0 {
                                if let formattedDuration: String = UniversalConverter.timeDurationFormatter.string(from: arrivalDate, to: departureDate) {
                                    annotation.subtitle = formattedDuration
                                }
                            }
                        }
                    }
                }
                                
                
                annotation.coordinate = CLLocationCoordinate2DMake(visit.latitude, visit.longitude)
                mapView.addAnnotation(annotation)
            }
        }
    }
    
}

// MARK: - Workout Routes

extension MapViewModel {
    
    func fetchWorkoutRoutes(completionHandler: @escaping ([[CLLocation]]) -> Void) {
        var locations: [[CLLocation]] = []
        
        HealthProfileDataStore.queryWorkoutRoutes(startDate: self.timestamp, endDate: self.timestamp.endOfDay()) { (routes: [WorkoutRoute]) in
            for route: WorkoutRoute in routes {
                let lock = DispatchSemaphore(value: 0)
                
                HealthProfileDataStore.queryWorkoutRouteLocations(workoutRoute: route) { (obj: [CLLocation]) in
                    locations.append(obj)
                    lock.signal()
                }
                
                lock.wait()
            }
            
            completionHandler(locations)
        }
    }
    
}
