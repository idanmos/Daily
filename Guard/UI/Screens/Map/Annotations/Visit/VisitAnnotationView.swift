//
//  VisitAnnotationView.swift
//  Guard
//
//  Created by Idan Moshe on 23/09/2020.
//  Copyright © 2020 Idan Moshe. All rights reserved.
//

import MapKit

class VisitAnnotationView: MKMarkerAnnotationView {
    
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
        self.markerTintColor = .systemGreen
        self.glyphImage = .house()
    }
    
}
