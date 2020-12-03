//
//  MapUtils.swift
//  Guard
//
//  Created by Idan Moshe on 05/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import MapKit
import Foundation
import CoreGraphics

class MapUtils {
    
    static let shared = MapUtils()
    
    class func takeSnapshot(latitude: Double, longitude: Double, completionHandler: @escaping (UIImage) -> Void) {
        let options = MKMapSnapshotter.Options()
        options.mapType = .standard
        options.showsBuildings = true
        options.size = CGSize(width: 200, height: 200)
        options.pointOfInterestFilter = .includingAll
        options.region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(latitude, longitude), latitudinalMeters: 200, longitudinalMeters: 200)
        options.scale = UIScreen.main.scale
        options.mapRect = MapUtils.shared.MKMapRectForCoordinateRegion(region: options.region)
        
        let snapshotter = MKMapSnapshotter(options: options)
        snapshotter.start { (mapSnapshotter: MKMapSnapshotter.Snapshot?, error: Error?) in
            if let error = error {
                Logger.shared.error("\(error)")
                return
            }
            
            guard let mapSnapshotter = mapSnapshotter else { return }
            
            let image = mapSnapshotter.image
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude)
            
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotation")

            UIGraphicsBeginImageContextWithOptions(image.size, true, image.scale)
            image.draw(at: .zero)
            
            let rect = CGRect(x: mapSnapshotter.point(for: CLLocationCoordinate2DMake(latitude, longitude)).x,
                              y: mapSnapshotter.point(for: CLLocationCoordinate2DMake(latitude, longitude)).y,
                              width: annotationView.frame.size.width,
                              height: annotationView.frame.size.height)
            
            annotationView.drawHierarchy(in: rect, afterScreenUpdates: true)
            /*
            let point = CGPoint(x: latitude, y: longitude)
            let size = CGSize(width: 100, height: 100)
            let rectangle = CGRect(x: point.x, y: point.y, width: size.width, height: size.height)
            let context = UIGraphicsGetCurrentContext()
            
            let redColor = UIColor.red.withAlphaComponent(0.4)
            
            context?.setFillColor(redColor.cgColor)
            context?.setStrokeColor(UIColor.green.cgColor)
            context?.setLineWidth(2.0)
            context?.addEllipse(in: rectangle)
            context?.drawPath(using: .fillStroke)
            */
            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let _ = finalImage {
                completionHandler(finalImage!)
            }
        }
    }
    
    func MKMapRectForCoordinateRegion(region: MKCoordinateRegion) -> MKMapRect {
        let topLeft = CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta/2), longitude: region.center.longitude - (region.span.longitudeDelta/2))
        let bottomRight = CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta/2), longitude: region.center.longitude + (region.span.longitudeDelta/2))

        let a = MKMapPoint(topLeft)
        let b = MKMapPoint(bottomRight)

        return MKMapRect(origin: MKMapPoint(x:min(a.x,b.x), y:min(a.y,b.y)), size: MKMapSize(width: abs(a.x-b.x), height: abs(a.y-b.y)))
    }
    
    class func formatDistance(distance: Double) -> String {
        let formatter = MKDistanceFormatter()
        formatter.locale = Locale.hebrewLocale
        formatter.units = .metric
        formatter.unitStyle = .full
        return formatter.string(fromDistance: distance)
    }
    
}

        // let trackingButton = MKUserTrackingButton(mapView: self.mapView)
//         self.navigationItem.rightBarButtonItem = MKUserTrackingBarButtonItem(mapView: self.mapView)
