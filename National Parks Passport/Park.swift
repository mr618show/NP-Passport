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
import CoreData


@objc (Park)
class Park: NSObject, MKAnnotation  {
    
    var name: String
    var summary: String
    var state: String
    var coordinate: CLLocationCoordinate2D
    var visited: Bool
    var title: String? {return name}
    var subtitle: String? {return state}
    
    var markerTinColor: UIColor {
        switch visited {
        case true :
            return UIColor(red: 0, green: 104.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        case false :
            return .gray
        }
    }
    var imageName: String? {
        let context = AppDelegate.viewContext
        if let tracker = self.fetchTracker(name: self.name, managedObjectContext: context).first {
            if tracker.visited {
                return "tree-color"
            } else {
                return "tree-grey"
            }
        }
        return "tree-grey"
    }
    
    init(name: String, summary: String, state: String, coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.summary = summary
        self.state = state
        self.coordinate = coordinate
        self.visited = false
    }
    static func < (lhs: Park, rhs: Park) -> Bool {
        return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
    }
    
    init(item: NSDictionary) {
        self.name = item.value(forKey: "fullName") as! String
        self.summary = item.value(forKey: "description") as! String
        self.state = item.value(forKey: "states") as! String
        self.visited = false
        let latLongString = item.value(forKey: "latLong") as! String
        let latitude = latLongString.getLatitude()!
        let longitude = latLongString.getLongitude()!
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func fetchTracker(name: String, managedObjectContext: NSManagedObjectContext)-> [NPTracker] {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "NPTracker")
        
        let predicate = NSPredicate(format: "name == %@", name)
  
        fetchRequest.predicate = predicate
        
        do {
            
            let results = try managedObjectContext.fetch(fetchRequest) as! [NPTracker]
            return results
            
        } catch let error as NSError {
            print(error)
        }
        return []
    }
    
}



