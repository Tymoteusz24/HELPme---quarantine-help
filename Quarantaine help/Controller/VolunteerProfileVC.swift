//
//  VolunteerProfileVCViewController.swift
//  Quarantaine help
//
//  Created by Tymoteusz Pasieka on 18/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import UIKit
import Cosmos

protocol VolunteerProfileVCDelegate {
    func didRankUser(volunteer: Volunteer)
}

class VolunteerProfileVC: UIViewController {

    @IBOutlet weak var buyMed: UIButton!
    @IBOutlet weak var doGroce: UIButton!
    @IBOutlet weak var walkADog: UIButton!
    @IBOutlet weak var chat: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    
    var volunteer: Volunteer?
    let defaults =  UserDefaults.standard
   
    
    var delegate : VolunteerProfileVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        // Do any additional setup after loading the view.
        cosmosView.didFinishTouchingCosmos = { rating in
            
            guard !self.checkIfAlreadyRated() else {
                self.createOKAlert(title: NSLocalizedString("Already rated", comment: "Already rated"), message: NSLocalizedString("You rated this user", comment: "You rated this user"))
                return
            }
            
            
            
            if let _ = self.delegate, let _ = self.volunteer {
                self.createYesNoAlert(title: NSLocalizedString("Rate volunteer", comment: "Rate volunteer"), message: NSLocalizedString("Do you want to rate volunteer", comment: "Do you want to rate volunteer") + " \(rating)") { (confirm) in
                    if confirm {
                        print("rate \(rating)")
                        
                   //     self.volunteer?.rate.append(Float(rating))
                        var ratingDefaults = self.defaults.object(forKey: "rating") as? [String] ?? [String]()
                        ratingDefaults.append(self.volunteer?.firebaseID ?? "")
                        self.defaults.set(ratingDefaults, forKey: "rating")
                        self.delegate?.didRankUser(volunteer: self.volunteer!)
                        self.updateRating()
                        self.requestReview()
                    }
                }
                
               
            }
            
            
        }
    }
    
    func checkIfAlreadyRated() -> Bool {
        print("defaults: \(defaults)")
        let ratingDefaults = defaults.object(forKey: "rating") as? [String] ?? [String]()
            for user in ratingDefaults {
                if let safeVolunteer = volunteer {
                    if safeVolunteer.firebaseID == user {
                        print("already ranked")
                        return true
                    }
                }
                return false
            }
        return false
    }
    
    func updateRating() {
        if let safeVolunteer = volunteer {
            if safeVolunteer.rate.count == 1 {
                cosmosView.rating = 0.0
                ratingLabel.text = "No raiting"
            } else {
               // let averageRaiting = safeVolunteer.rate.average
//                
//                cosmosView.rating = averageRaiting
//                ratingLabel.text =  String(format: "%.1f", averageRaiting) + "( \(safeVolunteer.rate.count - 1))"
                
            }
        }
    }
  
    
    func updateUI() {
        
//
//
//        if let safeVolunteer = volunteer {
//             statusLabel.text = safeVolunteer.name + NSLocalizedString(" is ready to help!", comment: " is ready to help!")
//            updateRating()
//
//
//            for help in safeVolunteer.kindOfHelp {
//                switch help {
//                case .buyMedicines:
//                    buyMed.isSelected = true
//                    buyMed.tintColor = K.Colors.bordo
//                    break
//                case .doGrocceries:
//                    doGroce.isSelected = true
//                    doGroce.tintColor = K.Colors.bordo
//                    break
//                case .walkADog:
//                    walkADog.isSelected = true
//                    walkADog.tintColor = K.Colors.bordo
//                    break
//                case .chat:
//                    chat.isSelected = true
//                    chat.tintColor = K.Colors.bordo
//                    break
//                }
//            }
//        }
    }
    

    @IBAction func goToFacebookPressed(_ sender: Any) {
//        if let url = volunteer?.facebookProfileUrl {
//                if UIApplication.shared.canOpenURL(url) {
//                    UIApplication.shared.open(url, options: [:])
//                }
//            }
//        
    }
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}




//MARK: - Extension for averege raiting

extension Collection where Element: Numeric {
    /// Returns the total sum of all elements in the array
    var total: Element { reduce(0, +) }
}

extension Collection where Element: BinaryFloatingPoint {
    /// Returns the average of all elements in the array
    var average: Double { isEmpty ? 0 : Double(total) / Double(count - 1) }
}
