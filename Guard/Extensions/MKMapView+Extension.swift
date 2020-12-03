//
//  MKMapView+Extension.swift
//  Guard
//
//  Created by Idan Moshe on 22/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import MapKit

extension MKMapView {
    /// SwifterSwift: Dequeue reusable MKAnnotationView using class type
    ///
    /// - Parameters:
    ///   - name: MKAnnotationView type.
    /// - Returns: optional MKAnnotationView object.
    func dequeueReusableAnnotationView<T: MKAnnotationView>(withClass name: T.Type) -> T? {
        return dequeueReusableAnnotationView(withIdentifier: String(describing: name)) as? T
    }

    /// SwifterSwift: Register MKAnnotationView using class type
    ///
    /// - Parameter name: MKAnnotationView type.
    @available(iOS 11.0, tvOS 11.0, macOS 10.13, *)
    func register<T: MKAnnotationView>(annotationViewWithClass name: T.Type) {
        register(T.self, forAnnotationViewWithReuseIdentifier: String(describing: name))
    }

    /// SwifterSwift: Dequeue reusable MKAnnotationView using class type
    ///
    /// - Parameters:
    ///   - name: MKAnnotationView type.
    ///   - annotation: annotation of the mapView.
    /// - Returns: optional MKAnnotationView object.
    @available(iOS 11.0, tvOS 11.0, macOS 10.13, *)
    func dequeueReusableAnnotationView<T: MKAnnotationView>(withClass name: T.Type,
                                                            for annotation: MKAnnotation) -> T? {
        guard let annotationView = dequeueReusableAnnotationView(
            withIdentifier: String(describing: name),
            for: annotation) as? T else {
            fatalError("Couldn't find MKAnnotationView for \(String(describing: name))")
        }

        return annotationView
    }
    
}
