//
//  Alert.swift
//  National Parks Passport
//
//  Created by Rui Mao on 11/17/18.
//  Copyright © 2018 Rui Mao. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    class func showBasic(title: String, message: String, vc: UIViewController){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString("OK", comment: "Localized name: OK"), style: .default, handler: nil)
        alert.addAction(action)
        vc.present(alert, animated: true, completion: nil)
    }
}
