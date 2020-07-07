//
//  InformationVCViewController.swift
//  Quarantaine help
//
//  Created by Tymoteusz Pasieka on 19/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import UIKit

class InformationVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    @IBAction func shareAppTapped(_ sender: RoundedButton) {
        
        shareApp()
    }
    
    @IBAction func policyTapped(_ sender: Any) {
        if let url = URL(string: "http://wheelo.com.pl/helpMePrivacy.html") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:])
            }
        }
        
    }
    
}
