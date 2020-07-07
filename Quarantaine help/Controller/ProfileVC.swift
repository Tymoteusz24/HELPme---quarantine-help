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

protocol ProfileVCDelegate {
    func didEditProfile(for volunteer: Volunteer)
    func didLogOut(for volunteer: Volunteer)
}

class ProfileVC: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView!
    @IBOutlet weak var ratingLabel: UILabel!

    
    @IBOutlet weak var buyMed: UIButton!
    @IBOutlet weak var doGroce: UIButton!
    @IBOutlet weak var walkADog: UIButton!
    @IBOutlet weak var chat: UIButton!
    
    private var kindOfHelps = [KindOfHelp]()
    var firebaseManager = FirebaseManager()
    
    var viewModel: CurrentVolunteerProfileViewModel
    var delegate: ProfileVCDelegate
    
    init?(coder: NSCoder, viewModel: CurrentVolunteerProfileViewModel, delegate: ProfileVCDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOut))

        updateUI()
        
    }
    
    
      @objc func logOut() {
              createYesNoAlert(title: NSLocalizedString("Log Out", comment: "Log Out"), message: NSLocalizedString("Are you sure that you want to delete volunteer account?", comment: "Are you sure that you want to delete volunteer account?")) {(result) in
                          if result {
                            self.firebaseManager.removeVolunteer(id: self.viewModel.volunteer.id)
                              FacebookLoginManager().logOut()
                            self.delegate.didLogOut(for: self.viewModel.volunteer)
                            self.navigationController?.popViewController(animated: true)
                          }
                      }
      }
    
    func updateUI() {
         cosmosView.isUserInteractionEnabled = false
        nameLabel.text = viewModel.volunteer.name
        cosmosView.rating = viewModel.raitingNumber
                   ratingLabel.text = viewModel.raitingLabel
                   
                   viewModel.returnKindOfHelps { (kindOfHelp) in
                       switch kindOfHelp {
                       case .buyMedicines:
                           buyMed.isSelected = true
                           buyMed.tintColor = K.Colors.bordo
                           break
                       case .doGrocceries:
                           doGroce.isSelected = true
                           doGroce.tintColor = K.Colors.bordo
                           break
                       case .walkADog:
                           walkADog.isSelected = true
                           walkADog.tintColor = K.Colors.bordo
                           break
                       case .chat:
                           chat.isSelected = true
                           chat.tintColor = K.Colors.bordo
                           break
                       }
                   }
    }
 
    
    @IBAction func kindOfHelpTapped(_ sender: UIButton) {
       
        
        let selected = sender.isSelected
              print("tag : \(sender.tag)")
              viewModel.updateKindOfHelp(KindOfHelp.allCases[sender.tag]) { (remove: Bool) in
                  sender.tintColor = remove ? .lightGray : K.Colors.bordo
                  sender.isSelected = !selected
              }
        
    }
    
    
    
    
    
    @IBAction func confirmTapped(_ sender: RoundedButton) {

        guard viewModel.kindOfHelps.count > 0 else {
                createOKAlert(title: NSLocalizedString("Select help type", comment: "Select help type"), message: NSLocalizedString("You must choose at least one thing.", comment: "You must choose at least one thing."))
            return
        }
        
        let resurce = Resource<Volunteer>(for: K.UserFirebaseKeys.users)
        firebaseManager.addNewVolunteer(resource: resurce, volunteer: viewModel.volunteer, id: viewModel.volunteer.id)
        delegate.didEditProfile(for: viewModel.volunteer)
    }
    
    
    
}
