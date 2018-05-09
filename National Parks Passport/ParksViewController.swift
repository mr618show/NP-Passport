//
//  ViewController.swift
//  National Parks Passport
//
//  Created by Rui Mao on 5/8/18.
//  Copyright © 2018 Rui Mao. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ParksViewController: UIViewController, CLLocationManagerDelegate  {

    @IBOutlet weak var mapView: MKMapView!
    var parks: [Park] = []
    private var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        loadAllParks()
        addPinforParks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //lookUpCurrentLocation()
        addPinforParks()

    }
    
    //set region
    
    func lookUpCurrentLocation() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation: CLLocation = locations[0] as CLLocation
        let viewRegion = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 4000, 4000)
        mapView.setRegion(viewRegion, animated: false)
        
    }
    
    func loadAllParks() {
        NPSAPIClient.shareInstance.fectchParks(success: { (parks: [Park]) in
            self.parks = parks
            print("Successfully loaded \(parks.count) parks")
        }) { (error: Error?) in
            print("error \(error?.localizedDescription ?? "Default Error String")")
        }
    }
    func addPinforParks() {
        NPSAPIClient.shareInstance.fectchParks(success: { (parks: [Park]) in
            for park in self.parks {
                print("\(park.name)")
                self.addAnnotationForPark(park: park)
            }
        }) { (error: Error?) in
            print("error \(error?.localizedDescription ?? "Default Error String")")
        }
    }
    
    func add(park: Park) {
        mapView.addAnnotation(park)
        
    }
    func addAnnotationForPark(park: Park) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = park.coordinate
        annotation.title = park.name
        mapView.addAnnotation(annotation)
        
    }
    
    

}

extension ParksViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "mapPin"
        if annotation is Park {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
            if annotationView == nil {
                annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            } else {
                annotationView?.annotation = annotation
            }
            return annotationView
        }
        return nil
    }
}

