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
import CoreData

class NPSAPIClient {
    static let shareInstance = NPSAPIClient()
    static var parks = [Park]()
    func fetchParks(success: @escaping ([Park]) -> (), failure: @escaping (Error?) -> ()) {
        let baseUrl = "https://developer.nps.gov/api/v1/parks?"
        let query = "limit=100&q=National%20Park&fields=images"
        let apikey = "cnQ86yV9EHAy3GulvrOYYbdrwdQMSVqVHY7B6mV6"
        let urlString  = "\(baseUrl)\(query)&api_key=\(apikey)"
        let url = URL(string: urlString)
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
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(with: data, options:[]) as? NSDictionary {
                        let retrievedData = responseDictionary["data"] as! [NSDictionary]
                        let predicate = NSPredicate(format: "designation CONTAINS[c] 'National Park'")
                        let filteredData = (retrievedData as NSArray).filtered(using: predicate) as! [NSDictionary]
                        for item in filteredData {
                            let park = Park(item: item)
                            NPSAPIClient.parks.append(park)
                            self.saveToCoreData(newPark: park)
                        }
                    }
                }
                success(NPSAPIClient.parks)
            }
        });
        task.resume()
    }
    func saveToCoreData(newPark:Park) {
        let context = AppDelegate.viewContext
        let tracker = NPTracker(context: context)
        tracker.name = newPark.name
        tracker.state = newPark.state
        tracker.visited = newPark.visited
        tracker.imageUrlString = newPark.imageUrlString
    }
    
    func fetchFromCoreData() -> [Park] {
        var fetchResult = [Park]()
        let context = AppDelegate.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "NPTracker")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for tracker in result as! [NSManagedObject] {
                let park = Park(name: tracker.value(forKey: "name") as! String , summary: tracker.value(forKey: "summary") as! String, state: tracker.value(forKey: "state") as! String, coordinate: CLLocationCoordinate2D(latitude: tracker.value(forKey: "latitude") as! Double, longitude: tracker.value(forKey: "longitude") as! Double), imageUrlString: tracker.value(forKey: "imageUrlString") as! String)
                fetchResult.append(park)
                
            }
            
        } catch {
            print("Failed")
            
        }
        return fetchResult
    }
}


