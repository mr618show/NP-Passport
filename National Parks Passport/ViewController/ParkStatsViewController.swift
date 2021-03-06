//
//  ParkStatsViewController.swift
//  National Parks Passport
//
//  Created by Rui Mao on 11/15/18.
//  Copyright © 2018 Rui Mao. All rights reserved.
//

import UIKit

class ParkStatsViewController: UIViewController {
    @IBOutlet weak var pieChartContainerView: UIView!
    @IBOutlet weak var staticLabel1: UILabel!
    @IBOutlet weak var staticLabel2: UILabel!
    @IBOutlet weak var countingLabel: CountingLabel!
    @IBOutlet weak var motivationLabel: UILabel!
    var parks: [Park] = [];
    var visitedParks: [Park] = [];
    var unVisitedParks: [Park] = [];
    override func viewDidLoad() {
        super.viewDidLoad()
        pieChartContainerView.backgroundColor = .clear
        //load parks from core data
        parks = NPSAPIClient.shareInstance.fetchFromCoreData()
        //calculate percentage
        visitedParks = parks.filter {$0.visited == true}
        unVisitedParks = parks.filter {$0.visited == false}
        //present UI
        let pieChartView = PieChartView()
        pieChartView.frame = CGRect(x: 0, y: 0, width: pieChartContainerView.frame.width, height: pieChartContainerView.frame.width)
        pieChartView.segments = [
            Segment(color: UIColor(red: 10/255, green: 80/255, blue: 80/255,
                                   alpha: 1), value: CGFloat(visitedParks.count) ),
            Segment(color: .lightGray, value: CGFloat(unVisitedParks.count))
        ]
        pieChartContainerView.addSubview(pieChartView)
        

        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        countingLabel.count(fromValue: 0, to: Float(visitedParks.count), withDuration: 0.5, andAnimationType: .EaseOut, andCounterType: .Int)
        var motivationLabelText: String {
            switch visitedParks.count {
            case 0:
                return "Get started with your first park!"
            case parks.count:
                return "Well done. You made it!"
            default:
                return "Good job. Keep it up!"
            }
        }
        motivationLabel.fadeTransition(0.8)
        motivationLabel.text = motivationLabelText
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
