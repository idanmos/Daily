//
//  LocationService.swift
//  Guard
//
//  Created by Idan Moshe on 19/08/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import CoreLocation
import CoreData
import UIKit

class LocationService: NSObject {
    
    // MARK: - Public Variables
    
    static let shared = LocationService()
    
    // MARK: - Private Variables
    
    private var locationManager: CLLocationManager!
    
    // MARK: - Public Methods
    
    class func isAuthorized() -> (Bool, String) {
        guard CLLocationManager.locationServicesEnabled() else {
            return (false, "locationServicesNotEnabled")
        }
        if CLLocationManager.authorizationStatus() == .authorizedAlways {
            return (true, "authorizedAlways")
        }
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            return (false, "authorizedWhenInUse")
        }
        return (false, "unknown")
    }
    
    func startUpdatingLocation() {
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.allowsBackgroundLocationUpdates = true
        self.locationManager.pausesLocationUpdatesAutomatically = false
        self.locationManager.distanceFilter = 100
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.activityType = .other
    }
    
    func startMonitoringVisits() {
        guard CLLocationManager.locationServicesEnabled() else { return }
        
        self.startUpdatingLocation()
        self.locationManager.startMonitoringVisits()
    }
    
    func stopMonitoringVisits() {
        self.locationManager.stopMonitoringVisits()
    }
    
}

// MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,  didFailWithError error: Error) {
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            manager.stopMonitoringVisits()
            manager.stopMonitoringSignificantLocationChanges()
            return
       }
       // Notify the user of any errors.
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            manager.requestAlwaysAuthorization()
        case .restricted, .denied:
            debugPrint("location authorization is restricted or denied")
        case .authorizedAlways:
            manager.startMonitoringVisits()
            manager.startMonitoringSignificantLocationChanges()
        case .authorizedWhenInUse:
            manager.requestAlwaysAuthorization()
            manager.startMonitoringVisits()
            manager.startMonitoringSignificantLocationChanges()
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard UIApplication.shared.applicationState != .active else { return }
        
        PersistentStorage.save(locations)
        
        for location: CLLocation in locations {
            self.saveCoordinates(location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        PersistentStorage.save(visit)
        self.saveCoordinates(visit.coordinate)
    }
    
    func saveCoordinates(_ coordinate: CLLocationCoordinate2D) {
        if !PersistentStorage.isAddressExists(coordinate: coordinate) {
            self.geocodeVisit(latitude: coordinate.latitude, longitude: coordinate.longitude) { (address: String?) in
                if let address = address {
                    PersistentStorage.save(address: address, coordinate: coordinate)
                }
            }
        }
    }
    
    func geocodeVisit(visit: CLVisit, completionHandler: @escaping () -> Void) {
        self.lookUpLocation(CLLocation(latitude: visit.coordinate.latitude, longitude: visit.coordinate.longitude)) { (placemark: CLPlacemark?) in
            guard let placemark = placemark else {
                
                return
            }
            let address = "\(placemark.name ?? ""), \(placemark.locality ?? "")"
            PersistentStorage.save(address: address, coordinate: visit.coordinate)
            completionHandler()
        }
    }
    
    func geocodeVisit(latitude: Double, longitude: Double, completionHandler: @escaping (String?) -> Void) {
        self.lookUpLocation(CLLocation(latitude: latitude, longitude: longitude)) { (placemark: CLPlacemark?) in
            guard let placemark = placemark else {
                completionHandler(nil)
                return
            }
            let address = "\(placemark.name ?? ""), \(placemark.locality ?? "")"
            if address.isEmpty {
                completionHandler(nil)
            } else {
                completionHandler(address)
            }
        }
    }
        
}

// MARK: - Geocode coordinates to address

extension LocationService {
    
    func lookUpLocation(_ location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void ) {
        let geocoder = CLGeocoder()
            
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks: [CLPlacemark]?, error: Error?) in
            if let _ = error {
                completionHandler(nil)
            } else {
                let firstLocation = placemarks?[0]
                completionHandler(firstLocation)
            }
        })
    }
    
}
