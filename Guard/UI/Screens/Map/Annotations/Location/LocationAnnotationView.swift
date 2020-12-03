//
//  LocationAnnotationView.swift
//  Daily
//
//  Created by Idan Moshe on 29/11/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import MapKit

class LocationAnnotationView: MKMarkerAnnotationView {

    static let reuseIdentifier = String(describing: type(of: self))
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        // self.collisionMode = .circle
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        self.displayPriority = .defaultHigh
        self.markerTintColor = .systemPurple
        self.glyphImage = .location()
    }

}
