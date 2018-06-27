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
    @IBOutlet weak var parkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var visitedSwitch: UISwitch!
    var park: Park?
    var trackerDelegate: NPTrackerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let park = park {
            nameLabel.text = park.name
            summaryLabel.text = park.summary
            let context = AppDelegate.viewContext
            if let tracker = park.fetchTracker(name: park.name, managedObjectContext: context).first {
                visitedSwitch.isOn = tracker.visited
                if tracker.imageUrlString != nil {
                    DispatchQueue.main.async {
                        self.parkImageView.loadImageUsingUrlString(urlString: tracker.imageUrlString!)
                    }
                    
                } else {
                    print ("can't load image")
                }
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
                print("switch is on")
                trackerDelegate.changeParkViewColor(park: currentPark, visited: true)
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            let context = AppDelegate.viewContext
            if let tracker = currentPark.fetchTracker(name: currentPark.name, managedObjectContext: context).first {
                tracker.visited = false
                print("switch is off")
                trackerDelegate.changeParkViewColor(park: currentPark, visited: false)
                self.dismiss(animated: true, completion: nil)
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
let imageCache = NSCache<NSString, UIImage>()
extension UIImageView {
    func loadImageUsingUrlString(urlString: String) {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        let url = NSURL(string: urlString)
        let urlRequest = URLRequest(url: url! as URL)
        URLSession.shared.dataTask(with: urlRequest as URLRequest, completionHandler: { (data, respose, error) in
            if error != nil {
                print(error)
                return
            }
            if let imageForCache = UIImage(data: data!) {
                imageCache.setObject(imageForCache as! UIImage, forKey: urlString as NSString)
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }

        }).resume()

    }

}
