//
//  ParkDetailViewController.swift
//  National Parks Passport
//
//  Created by Rui Mao on 5/13/18.
//  Copyright © 2018 Rui Mao. All rights reserved.
//

import UIKit

protocol NPTrackerDelegate {
    func changeParkViewColor(park: Park, visited: Bool)
    
}

class ParkDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var visitedSwitch: UISwitch!
    var park: Park?
    var trackerDelegate: NPTrackerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let park = park {
            print("getter: \(park.name)")
            nameLabel.text = park.name
            summaryLabel.text = park.summary
            let context = AppDelegate.viewContext
            if let tracker = park.fetchTracker(name: park.name, managedObjectContext: context).first {
                visitedSwitch.isOn = tracker.visited
            }
        }
        
        visitedSwitch.addTarget(self, action: #selector(ParkDetailViewController.switchValueChanged(sender:)), for: UIControlEvents.valueChanged)
       
    }
    @objc func switchValueChanged(sender: UISwitch!) {
        guard let currentPark = park else {return}

        if sender.isOn {
            let context = AppDelegate.viewContext
            if let tracker = currentPark.fetchTracker(name: currentPark.name, managedObjectContext: context).first {
                tracker.visited = true
                trackerDelegate.changeParkViewColor(park: currentPark, visited: true)
                self.dismiss(animated: true, completion: nil)
                print("current park \(currentPark.name), visited: \(currentPark.visited)")
            }
        } else {
            let context = AppDelegate.viewContext
            if let tracker = currentPark.fetchTracker(name: currentPark.name, managedObjectContext: context).first {
                tracker.visited = false
                trackerDelegate.changeParkViewColor(park: currentPark, visited: false)
                self.dismiss(animated: true, completion: nil)
                print("current park \(currentPark.name), visited: \(currentPark.visited)")

            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
