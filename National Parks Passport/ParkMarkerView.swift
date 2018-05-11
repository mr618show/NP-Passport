//
//  ParkMarkerView.swift
//  National Parks Passport
//
//  Created by Rui Mao on 5/11/18.
//  Copyright © 2018 Rui Mao. All rights reserved.
//

import Foundation
import MapKit


class ParkMarkerView: MKMarkerAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let park = newValue as? Park else { return }
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: -5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            markerTintColor = park.markerTinColor
            glyphText = String(park.visited)
        }
    }
}
