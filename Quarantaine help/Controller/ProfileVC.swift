//
//  ProfileVC.swift
//  Quarantaine help
//
//  Created by Tymoteusz Pasieka on 18/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import UIKit
import Cosmos
import FBSDKLoginKit

protocol ProvileVCDelegate {
    func didEditProfile(for volunteer: Volunteer)
    func didLogOut(for volunteer: Volunteer)
}

class ProfileVC: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    
    @IBOutlet weak var buyMed: UIButton!
    @IBOutlet weak var doGroce: UIButton!
    @IBOutlet weak var walkADog: UIButton!
    @IBOutlet weak var chat: UIButton!
    
    private var kindOfHelps = [KindOfHelp]()
    var volunteer: Volunteer?
    var delegate: ProvileVCDelegate?
    var firebaseManager = FirebaseManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cosmosView.isUserInteractionEnabled = false
        updateUI()
//        if let safeVolunteer = volunteer {
//            kindOfHelps = safeVolunteer.kindOfHelp
//        }
      
        // Do any additional setup after loading the view.
        
    }
    
    private func removeKindOfHelp(_ element: KindOfHelp) {
        if let index = kindOfHelps.firstIndex(of: element) {
               kindOfHelps.remove(at: index)
           }
       }
    
    /// updating ui from volunteer
    
    func updateRating() {
        if let safeVolunteer = volunteer {
            if safeVolunteer.rate.count == 1 {
                cosmosView.rating = 0.0
                ratingLabel.text = NSLocalizedString("No raiting", comment: "No raiting")
            } else {
             //   let averageRaiting = safeVolunteer.rate.average
                
//                cosmosView.rating = averageRaiting
//                ratingLabel.text =  String(format: "%.1f", averageRaiting) + "(\(safeVolunteer.rate.count - 1))"
                
            }
        }
    }
    
    func updateUI() {
//      
//           if let safeVolunteer = volunteer {
//            nameLabel.text = safeVolunteer.name
//            updateRating()
//            
//               for help in safeVolunteer.kindOfHelp {
//                   switch help {
//                   case .buyMedicines:
//                       buyMed.isSelected = true
//                       buyMed.tintColor = K.Colors.bordo
//                       break
//                   case .doGrocceries:
//                       doGroce.isSelected = true
//                       doGroce.tintColor = K.Colors.bordo
//                       break
//                   case .walkADog:
//                       walkADog.isSelected = true
//                       walkADog.tintColor = K.Colors.bordo
//                       break
//                   case .chat:
//                       chat.isSelected = true
//                       chat.tintColor = K.Colors.bordo
//                       break
//                   }
//               }
//           }
    }
    
    
    @IBAction func kindOfHelpTapped(_ sender: UIButton) {
         let selected = sender.isSelected
        
             switch sender.tag {
             case 0:
                 selected ? removeKindOfHelp(KindOfHelp.buyMedicines) : kindOfHelps.append(KindOfHelp.buyMedicines)
                 break
             case 1:
                 selected ? removeKindOfHelp(KindOfHelp.doGrocceries) : kindOfHelps.append(KindOfHelp.doGrocceries)
                 break
             case 2:
                 selected ? removeKindOfHelp(KindOfHelp.walkADog) : kindOfHelps.append(KindOfHelp.walkADog)
                 break
             case 3:
                 selected ? removeKindOfHelp(KindOfHelp.chat) : kindOfHelps.append(KindOfHelp.chat)
                 break
             default:
                 print("none")
                 break
         }
         sender.tintColor = selected ? .lightGray : K.Colors.bordo
         sender.isSelected = !selected
        
    }
    
    
    
    @IBAction func logOutPressed(_ sender: UIButton) {
        let loginManager = LoginManager()
        if let _  = AccessToken.current {
            createYesNoAlert(title: NSLocalizedString("Log Out", comment: "Log Out"), message: NSLocalizedString("Are you sure that you want to delete volunteer account?", comment: "Are you sure that you want to delete volunteer account?")) { (result) in
                if result {
                    self.firebaseManager.removeVolunteer()
                    loginManager.logOut()
                    print("Logut")
                    if let _ = self.delegate, let safeVolunteer = self.volunteer {
                        self.delegate?.didLogOut(for: safeVolunteer)
                    }
                    self.dismiss(animated: true, completion: nil)
                    
                } 
            }
            
        }
    }
    
    
    @IBAction func confirmTapped(_ sender: RoundedButton) {
            guard kindOfHelps.count>0 else {
                createOKAlert(title: NSLocalizedString("Select help type", comment: "Select help type"), message: NSLocalizedString("You must choose at least one thing.", comment: "You must choose at least one thing."))
                return
               }
        if let _ = volunteer {
         //   volunteer?.kindOfHelp = kindOfHelps
            if let _ = delegate {
                delegate?.didEditProfile(for: volunteer!)
            }
        }
    }
    
    @IBAction func backBtnTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}
