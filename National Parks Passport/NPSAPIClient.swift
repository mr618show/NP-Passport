//
//  NPSAPIClient.swift
//  National Parks Passport
//
//  Created by Rui Mao on 5/8/18.
//  Copyright © 2018 Rui Mao. All rights reserved.
//

import Foundation

class NPSAPIClient {
    static let shareInstance = NPSAPIClient()
    var parks = [Park]()
    func fectchParks() {
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
                        let retrievedData = responseDictionary["data"] as! [NSDictionary]
                        for item in retrievedData {
                            let park = Park()
                            park.name = item.value(forKey: "fullName") as! String
                            park.summary = item.value(forKey: "description") as! String
                            let latLongString = item.value(forKey: "latLong") as! String
                            park.latitude = latLongString.getLatitude()!
                            park.longitude = latLongString.getLongitude()!
                            self.parks.append(park)
                        }
                        print(self.parks.count)
                    }
                }
            }
        });
        task.resume()
    }
}


