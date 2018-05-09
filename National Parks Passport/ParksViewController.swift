//
//  ViewController.swift
//  National Parks Passport
//
//  Created by Rui Mao on 5/8/18.
//  Copyright © 2018 Rui Mao. All rights reserved.
//

import UIKit
import AFNetworking

class ParksViewController: UIViewController  {

    @IBOutlet weak var tableView: UITableView!
    
    var parks: [NSDictionary] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 300
        fetchParks()

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc func fetchParks() {
        let baseUrl = "https://developer.nps.gov/api/v1/parks?"
        let apikey = "cnQ86yV9EHAy3GulvrOYYbdrwdQMSVqVHY7B6mV6"
        let url = URL(string:"\(baseUrl)api_key=\(apikey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue:OperationQueue.main
        )
        let task : URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            if let httpError = error {
                print("\(httpError)")
            } else {
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                        self.parks = responseDictionary["data"] as! [NSDictionary]
                        print(self.parks.count)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        });
        task.resume()
    }
}



extension ParksViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return parks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = parks[indexPath.row].value(forKey: "fullName") as? String
        
        return cell
    }
    
}

