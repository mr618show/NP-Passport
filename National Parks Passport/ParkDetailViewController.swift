//
//  ParkDetailViewController.swift
//  National Parks Passport
//
//  Created by Rui Mao on 5/13/18.
//  Copyright © 2018 Rui Mao. All rights reserved.
//

import UIKit

class ParkDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var visitedSwitch: UISwitch!
    var park: Park?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let park = park {
            nameLabel.text = park.name
            summaryLabel.text = park.summary
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
