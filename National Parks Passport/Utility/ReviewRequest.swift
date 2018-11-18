//
//  ReviewRequest.swift
//  National Parks Passport
//
//  Created by Rui Mao on 11/18/18.
//  Copyright © 2018 Rui Mao. All rights reserved.
//

import Foundation
import StoreKit

let runIncrementerSetting = "numberOfRuns"
func incrementAppRuns() {
    let ud = UserDefaults()
    let runs = getRunCounts() + 1
    ud.set(runs, forKey: runIncrementerSetting)
    
}

func getRunCounts() -> Int {
    let ud = UserDefaults.standard
    let savedRuns = ud.value(forKey: runIncrementerSetting )
    var runs = 0
    if (savedRuns != nil) {
        runs = savedRuns as! Int
    }
    print("The app is opened: \(runs) times")
    return runs
}

func showReview(){
    let runs = getRunCounts()
    print("Show Review")
    if (runs % 5 == 0) {
        if #available(iOS 10.3, *) {
            print("Counts reaches 5")
            SKStoreReviewController.requestReview()
        } else {
            // Fallback on earlier versions
        }
    } else {
        print ("Runs are not enought to request review!")
    }
}
