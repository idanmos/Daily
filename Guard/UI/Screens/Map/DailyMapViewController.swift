//
//  DailyMapViewController.swift
//  Guard
//
//  Created by Idan Moshe on 23/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation.CLLocation
import FirebaseAnalytics
import GoogleMobileAds

class DailyMapViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var mapView: MKMapView!
    
    // MARK: - Properties
    
    /// - Tag: Map
    private var userTrackingButton: MKUserTrackingButton!
    private var scaleView: MKScaleView!
    
    /// - Tag: Data source
    private var mapViewModel = MapViewModel()
    private var locations: [[CLLocation]] = []
//    private var visits: [Visit] = []
    private var workoutRoutes: [WorkoutRoute] = []
        
    private var interstitial: GADInterstitial!
    
    private lazy var datePickerController: UIDatePickerViewController = {
        let picker = UIDatePickerViewController(nibName: String(describing: UIDatePickerViewController.self), bundle: nil)
        picker.modalPresentationStyle = .overCurrentContext
        picker.delegate = self
        return picker
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        /* DispatchQueue.global(qos: .background).async {
            let workouts: [Workout] = PreferenceManager.currentSession.getWorkouts()
            for workout in workouts {
                let lock = DispatchSemaphore(value: 0)
                
                HealthProfileDataStore.queryWorkoutRoutes(startDate: workout.startDate, endDate: workout.endDate) { [weak self] (route: [WorkoutRoute]) in
                    guard let self = self else {
                        lock.signal()
                        return
                    }
                    
                    self.workoutRoutes.append(contentsOf: route)
                    
                    lock.signal()
                }
                
                lock.wait()
            }
            
            DispatchQueue.main.async {
                self.addWorkoutRoutesToMap {
                    debugPrint("self.addWorkoutRoutesToMap")
                }
            }
        } */
        
        Analytics.logEvent(AnalyticsEventScreenView, parameters: nil)
        
        var title: String = ""
        if Calendar.current.isDateInToday(self.mapViewModel.timestamp) {
            title = Localization.today.preferredLocalization
        } else if Calendar.current.isDateInYesterday(self.mapViewModel.timestamp) {
            title = Localization.yesterday.preferredLocalization
        } else {
            title = DateFormatter.dateOnly.string(from: self.mapViewModel.timestamp)
        }
        self.navigationItem.title = title
        
        // self.setupCompassButton()
        self.setupUserTrackingButtonAndScaleView()
        self.registerAnnotations()
                
        let authorizationStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        let locationAuthorized: Bool = (authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse)
        self.userTrackingButton.isHidden = !locationAuthorized
        
        self.mapViewModel.addAnnotations(mapView: self.mapView)
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
        }
        
        self.interstitial = GADInterstitial(adUnitID: Application.GoogleAdMob.bannerId)
        let request = GADRequest()
        self.interstitial.load(request)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
            if self.interstitial.isReady {
                self.interstitial.present(fromRootViewController: self)
            }
        }
    }
    
    // MARK: - Setup
    
    private func setupCompassButton() {
        let compass = MKCompassButton(mapView: self.mapView)
        compass.compassVisibility = .visible
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: compass)
        self.mapView.showsCompass = false
    }
    
    private func setupUserTrackingButtonAndScaleView() {
        self.mapView.showsUserLocation = true
        
        self.userTrackingButton = MKUserTrackingButton(mapView: self.mapView)
        self.userTrackingButton.isHidden = true // Unhides when location authorization is given.
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.userTrackingButton)
        
        // By default, `MKScaleView` uses adaptive visibility, so it only displays when zooming the map.
        // This is behavior is confirgurable with the `scaleVisibility` property.
        self.scaleView = MKScaleView(mapView: self.mapView)
        self.scaleView.legendAlignment = .trailing
        view.addSubview(self.scaleView)
        
        let stackView = UIStackView(arrangedSubviews: [self.scaleView, self.userTrackingButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
                                     stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)])
    }
    
    // MARK: - General Methods
    
    private func registerAnnotations() {
        self.mapView.register(VisitAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        self.mapView.register(WorkoutAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
    }
    
    private func calculateDistance(locations: [CLLocation]) -> CLLocationDistance {
        var totalDistance: CLLocationDistance = 0.0
        if !locations.isEmpty {
            for (index, location) in locations.enumerated() {
                if index == locations.count-1 {
                    break
                }
                let distance = location.distance(from: locations[index+1])
                totalDistance += distance
            }
        }
        return totalDistance
    }
    
}

extension DailyMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyline = overlay as? MKPolyline else {
            return MKOverlayRenderer()
        }

        let polylineRenderer = MKPolylineRenderer(overlay: polyline)
        polylineRenderer.strokeColor = .systemBlue
        polylineRenderer.lineWidth = 10
        return polylineRenderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? VisitAnnotation {
            let annotationView = VisitAnnotationView(annotation: annotation, reuseIdentifier: VisitAnnotationView.reuseIdentifier)
            annotationView.detailCalloutAccessoryView = nil
            return annotationView
        } else if let annotation = annotation as? WorkoutAnnotation {
            let annotationView = WorkoutAnnotationView(annotation: annotation, reuseIdentifier: WorkoutAnnotationView.reuseIdentifier)
            annotationView.detailCalloutAccessoryView = nil
            return annotationView
        } else if let annotation = annotation as? LocationAnnotation {
            let annotationView = LocationAnnotationView(annotation: annotation, reuseIdentifier: LocationAnnotationView.reuseIdentifier)
            annotationView.detailCalloutAccessoryView = nil
            return annotationView
        }
        
        return nil
    }
    
}

// MARK: - Add map data

extension DailyMapViewController {
    
    private func queryWorkoutRouteLocations() -> [[CLLocation]] {
        guard !self.workoutRoutes.isEmpty else { return [] }
        
        var objs: [[CLLocation]] = []
                
        for route: WorkoutRoute in self.workoutRoutes {
            let semaphore = DispatchSemaphore(value: 0)
            
            HealthProfileDataStore.queryWorkoutRouteLocations(workoutRoute: route) { (locationsInternal: [CLLocation]) in
                objs.append(locationsInternal)
                semaphore.signal()
            }
            
            semaphore.wait()
        }
        
        return objs
    }
    
    private func addWorkoutRoutesToMap(completionHandler: @escaping () -> Void) {
        /*
        let objs: [[CLLocation]] = self.queryWorkoutRouteLocations()
        self.locations.append(contentsOf: objs)
        
        guard !self.locations.isEmpty else {
            completionHandler()
            return
        }
        guard self.locations[0].count > 1 else {
            completionHandler()
            return
        }
        
        DispatchQueue.main.async {
            var totalDistance: CLLocationDistance = 0
            
            var coordinates: [[CLLocationCoordinate2D]] = []
            for locationsInternal: [CLLocation] in self.locations {
                let distanceInSegment: CLLocationDistance = self.calculateDistance(locations: locationsInternal)
                totalDistance += distanceInSegment
                
                var coordinate: [CLLocationCoordinate2D] = []
                for (index, location) in locationsInternal.enumerated() {
                    coordinate.append(location.coordinate)
                    
                    let subtitle = "\(self.dateFormatter.string(from: location.timestamp))"
                    
                    if index == 0 { // First
                        let annotation = WorkoutAnnotation()
                        annotation.title = "Workout - Start"
                        annotation.subtitle = subtitle
                        annotation.coordinate = location.coordinate
                        annotation.phase = .start
                        self.mapView.addAnnotation(annotation)
                    } else if index == locationsInternal.count-1 { // Last
                        let annotation = WorkoutAnnotation()
                        annotation.title = "Workout - End"
                        annotation.subtitle = subtitle
                        annotation.coordinate = location.coordinate
                        annotation.phase = .end
                        self.mapView.addAnnotation(annotation)
                    }
                }
                coordinates.append(coordinate)
            }
            
            let flatternLocations = self.locations.reduce([], +) // Flattern the 2d array to 1d array
            let sortedLocations = flatternLocations.sorted { (obj1: CLLocation, obj2: CLLocation) -> Bool in
                return obj1.timestamp < obj2.timestamp
            }
            
            if let firstLocation: CLLocation = sortedLocations.first,
                let lastLocation: CLLocation = sortedLocations.last {
                // Active energy burned
                let activeEnergyBurned: Double = HealthProfileDataStore.queryActiveEnergyBurned(startDate: firstLocation.timestamp, endDate: lastLocation.timestamp)
                debugPrint(("Active Energy\nBurned", String(format: "%.2f", activeEnergyBurned)))
                
                // Heart rate
                let averageHeartRate: Double = HealthProfileDataStore.queryAvarageHeartRate(startDate: firstLocation.timestamp, endDate: lastLocation.timestamp)
                debugPrint(("Average Heart\nRate", "\(averageHeartRate)"))
            }
            
            var polylines: [MKPolyline] = []
            
            for coordinate: [CLLocationCoordinate2D] in coordinates {
                polylines.append(MKPolyline(coordinates: coordinate, count: coordinate.count))
            }
            
            self.mapView.addOverlays(polylines)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            }
            
            completionHandler()
        }
 */
    }
    
}

// MARK: - Actions

extension DailyMapViewController {
    
    @IBAction func onPressCalendar(_ sender: Any) {
        self.present(self.datePickerController, animated: true, completion: nil)
    }
    
}

// MARK: - DatePickerViewControllerDelegate

extension DailyMapViewController: UIDatePickerViewControllerDelegate {
    
    func datePickerController(_ picker: UIDatePickerViewController, didFinishPickingDate date: Date) {
        picker.dismiss(animated: true, completion: nil)
        
        self.mapViewModel.timestamp = date
        self.mapViewModel.addAnnotations(mapView: self.mapView)
        
        self.navigationItem.title = date.getTitle()
    }
    
    func datePickerControllerDidCancel(_ picker: UIDatePickerViewController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}
