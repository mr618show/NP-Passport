//
//  Parks.swift
//  National Parks Passport
//
//  Created by Rui Mao on 5/8/18.
//  Copyright © 2018 Rui Mao. All rights reserved.
//

import Foundation

class Park: NSObject {
    var name = ""
    var summary = ""
    var latitude = 0.0
    var longitude = 0.0
    var visited = NSDate()
    
    static func < (lhs: Park, rhs: Park) -> Bool {
        return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
    }
    
}
