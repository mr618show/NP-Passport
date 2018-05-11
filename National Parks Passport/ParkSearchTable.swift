//
//  ParkSearchTable.swift
//  National Parks Passport
//
//  Created by Rui Mao on 5/9/18.
//  Copyright © 2018 Rui Mao. All rights reserved.
//

import UIKit
import MapKit


class ParkSearchTable: UITableViewController {
    var matchingItems: [String]!
    var parkNames = [String]()
    var handleMapSearchDelegate: HandleMapSearch? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let parks = NPSAPIClient.parks
        
        view.backgroundColor = .clear
        print("park count: \(parks.count)")
        for park in parks {
            let parkName = park.name
            self.parkNames.append(parkName)
        }
    }
    
}

extension ParkSearchTable : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            matchingItems = searchText.isEmpty ? parkNames : parkNames.filter({(dataString: String) -> Bool in
                return dataString.range(of: searchText, options: .caseInsensitive) != nil
            })
            tableView.reloadData()
        }
    }
}

extension ParkSearchTable {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchingItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkSearchTableCell")!
        cell.textLabel?.text = matchingItems[indexPath.row]
        cell.detailTextLabel?.text = ""
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedParkName = matchingItems[indexPath.row]
        print("selected Park: \(selectedParkName)")
        let selectedPark = NPSAPIClient.parks.filter{$0.name == selectedParkName}.first
        handleMapSearchDelegate?.dropPinZoomIn(park: selectedPark!)
        dismiss(animated: true, completion: nil)
    }
    
}




