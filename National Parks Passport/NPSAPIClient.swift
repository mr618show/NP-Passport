//
//  NPSAPIClient.swift
//  National Parks Passport
//
//  Created by Rui Mao on 5/8/18.
//  Copyright © 2018 Rui Mao. All rights reserved.
//

import Foundation
import AFNetworking
import MapKit
import CoreLocation

class NPSAPIClient {
    static let shareInstance = NPSAPIClient()
    static var parks = [Park]()
    func fectchParks(success: @escaping ([Park]) -> (), failure: @escaping (Error?) -> ()) {
        let baseUrl = "https://developer.nps.gov/api/v1/parks?"
        let constraint = "limit=1000"
        let apikey = "cnQ86yV9EHAy3GulvrOYYbdrwdQMSVqVHY7B6mV6"
        let url = URL(string:"\(baseUrl)\(constraint)&api_key=\(apikey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate: nil,
            delegateQueue:OperationQueue.main
        )
        let task : URLSessionDataTask = session.dataTask(with: request as URLRequest,completionHandler: { (dataOrNil, response, error) in
            if let httpError = error {
                failure(error)
                print("\(httpError)")
            } else {
                //var parks = [Park]()
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                        let retrievedData = responseDictionary["data"] as! [NSDictionary]
                        let predicate = NSPredicate(format: "designation CONTAINS[c] 'National Park'")
                        let filteredData = (retrievedData as NSArray).filtered(using: predicate) as! [NSDictionary]
                        for item in filteredData {
                            let park = Park(item: item)
                            NPSAPIClient.parks.append(park)
                        }
                    }
                }
                success(NPSAPIClient.parks)
            }
        });
        task.resume()
    }
}


