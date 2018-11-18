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
    var parks = [Park]()
    var handleMapSearchDelegate: HandleMapSearch? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        if !NPSAPIClient.shareInstance.isEmpty {
            parks = NPSAPIClient.shareInstance.fetchFromCoreData()
            print("core data has \(parks.count) parks")
        } else {
            parks = NPSAPIClient.parks
        }
        view.backgroundColor = .clear
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
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
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
        cell.textLabel?.font = UIFont(name: "Noteworthy", size: 15)
        cell.textLabel?.textColor = .white
        cell.textLabel?.backgroundColor = UIColor(red: 25/255, green: 42/255, blue: 62/255, alpha: 0.5)
        cell.contentView.backgroundColor = UIColor(red: 226/255, green: 225/255, blue: 216/255, alpha: 0.5)
        cell.detailTextLabel?.text = ""
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedParkName = matchingItems[indexPath.row]
        let selectedPark = parks.filter{$0.name == selectedParkName}.first
        DispatchQueue.main.async {
            self.handleMapSearchDelegate?.dropPinZoomIn(park: selectedPark!)
        }
        dismiss(animated: true, completion: nil)
    }
    
}




