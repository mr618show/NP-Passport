//
//  Parks.swift
//  National Parks Passport
//
//  Created by Rui Mao on 5/8/18.
//  Copyright © 2018 Rui Mao. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation

class Park: NSObject, MKAnnotation {
    
    var name: String
    var summary: String
    var coordinate: CLLocationCoordinate2D
    //var latitude = 0.0
    //var longitude = 0.0
    //var visited = NSDate()
    
    init(name: String, summary: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.summary = summary
        self.coordinate = coordinate
    }
    static func < (lhs: Park, rhs: Park) -> Bool {
        return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
    }
    
    init(item: NSDictionary) {
        self.name = item.value(forKey: "fullName") as! String
        self.summary = item.value(forKey: "description") as! String
        let latLongString = item.value(forKey: "latLong") as! String
        let latitude = latLongString.getLatitude()!
        let longitude = latLongString.getLongitude()!
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}
