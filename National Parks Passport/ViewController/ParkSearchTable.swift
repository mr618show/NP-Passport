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
        tableView.register(UINib(nibName: "ParkSearchTableViewCell", bundle: nil), forCellReuseIdentifier: "ParkSearchTableViewCell")
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
    
    func utf8DecodedString(input: String)-> String {
        let data = input.data(using: .utf8)
        if let message = String(data: data!, encoding: .nonLossyASCII){
            return message
        }
        return ""
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ParkSearchTableViewCell", for: indexPath) as! ParkSearchTableViewCell
        //Todo convert special foreign character
        if (matchingItems[indexPath.row].contains("Haleaka")) {
            cell.parkNameLabel?.text = "Haleakalā National Park"
        } else {
            cell.parkNameLabel?.text = matchingItems[indexPath.row]
        }
        
        cell.parkNameLabel?.numberOfLines = 0
        cell.parkNameLabel?.lineBreakMode = .byWordWrapping
        cell.parkNameLabel?.font = UIFont(name: "Helvetica", size: 16)
        cell.selectionStyle = .gray
        cell.parkNameLabel?.textColor = .white
        //cell.contentView.backgroundColor =
        cell.backgroundColor = UIColor(red: 32/255, green: 54/255, blue: 79/255, alpha: 0.7)
            
         //   UIColor(red: 216/255, green: 225/255, blue: 216/255, alpha: 0.5)
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






