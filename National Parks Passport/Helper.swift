//
//  Helper.swift
//  National Parks Passport
//
//  Created by Rui Mao on 5/8/18.
//  Copyright © 2018 Rui Mao. All rights reserved.
//

import Foundation

extension String {
    func getLatitude() -> Double? {
        let latString = self.components(separatedBy: ",").first!.components(separatedBy: ":").last
        return NSString(string: latString!).doubleValue
    }
    
    func getLongitude() -> Double? {
        let longString = self.components(separatedBy: ",").last!.components(separatedBy: ":").last
        return NSString(string: longString!).doubleValue
    }
}


