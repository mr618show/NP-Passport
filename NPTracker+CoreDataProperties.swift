//
//  NPTracker+CoreDataProperties.swift
//  
//
//  Created by Rui Mao on 5/13/18.
//
//

import Foundation
import CoreData


extension NPTracker {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NPTracker> {
        return NSFetchRequest<NPTracker>(entityName: "NPTracker")
    }

    @NSManaged public var lantitude: Double
    @NSManaged public var lastDateVisited: NSDate?
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var state: String?
    @NSManaged public var visited: Bool
    
    


}
