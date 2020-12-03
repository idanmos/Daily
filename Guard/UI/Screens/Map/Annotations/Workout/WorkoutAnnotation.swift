//
//  WorkoutAnnotation.swift
//  Guard
//
//  Created by Idan Moshe on 23/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import MapKit

class WorkoutAnnotation: NSObject, Decodable, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    
    enum WorkoutPhase: Int, Decodable {
        case start
        case end
    }
    
    var phase: WorkoutPhase = .start
    
    private var latitude: CLLocationDegrees = 0
    private var longitude: CLLocationDegrees = 0
    
    // This property must be key-value observable, which the `@objc dynamic` attributes provide.
    @objc dynamic var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(latitude, longitude)
        }
        set {
            // For most uses, `coordinate` can be a standard property declaration without the customized getter and setter shown here.
            // The custom getter and setter are needed in this case because of how it loads data from the `Decodable` protocol.
            latitude = newValue.latitude
            longitude = newValue.longitude
        }
    }
    
}
