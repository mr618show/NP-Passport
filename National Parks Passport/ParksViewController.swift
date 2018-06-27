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
import CoreData

protocol HandleMapSearch {
    func dropPinZoomIn(park: Park)
}

class ParksViewController: UIViewController, CLLocationManagerDelegate  {

    @IBOutlet weak var mapView: MKMapView!
    var parks: [Park] = []
    private var locationManager: CLLocationManager!
    var resultSearchController: UISearchController? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.register(ParkView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)

        loadAllParks()
        let parkSearchTable = storyboard!.instantiateViewController(withIdentifier: "ParkSearchTable") as! ParkSearchTable
        resultSearchController = UISearchController(searchResultsController: parkSearchTable)
        resultSearchController?.searchResultsUpdater = parkSearchTable as UISearchResultsUpdating
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.delegate = self
        navigationController?.navigationBar.barTintColor = UIColor(red: 0, green: 104.0/255.0, blue: 55.0/255.0, alpha: 1.0)
        searchBar.tintColor = .white
        searchBar.placeholder = "Search for a park"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true
        parkSearchTable.handleMapSearchDelegate = self
    }
    
    @IBAction func onRestButton(_ sender: UIButton) {
        lookUpCurrentLocation()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lookUpCurrentLocation()
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
        let viewRegion = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate, 4000000, 4000000)
        mapView.setRegion(viewRegion, animated: false)
        
    }
    
    func loadAllParks() {
        NPSAPIClient.shareInstance.fetchParks(success: { (parks: [Park]) in
            self.parks = parks
            print("Successfully loaded \(parks.count) parks")
            DispatchQueue.main.async {
                for park in self.parks {
                    self.mapView.addAnnotation(park)
                }
            }
        }) { (error: Error?) in
            print("error \(error?.localizedDescription ?? "Problem loading parks")")
        }
    }
}

extension ParksViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? Park {
        performSegue(withIdentifier: "parkDetailSegue", sender: annotation)
        }
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "parkDetailSegue" {
            if let park = sender as? Park {
                let detailGroupVC = segue.destination as! ParkDetailViewController
                detailGroupVC.park = park
                detailGroupVC.trackerDelegate = self
            }
        }
    }
}

extension ParksViewController: UISearchBarDelegate {

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.placeholder = "Search for a park"
    }
}

extension ParksViewController: HandleMapSearch {
    func dropPinZoomIn(park: Park) {
        mapView.addAnnotation(park)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(park.coordinate, span)
        mapView.setRegion(region, animated: true)
    }
}

extension ParksViewController: NPTrackerDelegate {
    func changeParkViewColor(park: Park, visited: Bool) {
        let target = parks.filter{$0.name == park.name}.first
        mapView.removeAnnotation(target!)
        target?.visited = visited
        mapView.addAnnotation(target!)
    }
}


