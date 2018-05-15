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
            print("getter: \(park.name)")
            nameLabel.text = park.name
            summaryLabel.text = park.summary
            let imageUrl = URL(string: park.imageUrl)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageUrl!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                DispatchQueue.main.async {
                    self.parkImageView.image = UIImage(data: data!)
                }
            }
            //parkImageView.downloadedFrom(link: imageUrl)
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
            }
        } else {
            let context = AppDelegate.viewContext
            if let tracker = currentPark.fetchTracker(name: currentPark.name, managedObjectContext: context).first {
                tracker.visited = false
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

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}
