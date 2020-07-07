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
        
        var viewModel: VolunteerProfileProtocol
        var delegate : VolunteerProfileVCDelegate
        
        init?(coder: NSCoder, viewModel: VolunteerProfileProtocol, delegate: VolunteerProfileVCDelegate) {
            self.viewModel = viewModel
            self.delegate = delegate
            super.init(coder: coder)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            updateUI()
            handleComosViewTouch()
            
        }
        
        func handleComosViewTouch() {
            let vm = viewModel as! VolunteerProfileViewModel
            cosmosView.didFinishTouchingCosmos = { raiting in
                vm.rateUser(rate: raiting) { (alreadyRated) in
                    if alreadyRated {
                        self.createOKAlert(title: NSLocalizedString("Already rated", comment: "Already rated"), message: NSLocalizedString("You rated this user", comment: "You rated this user"))
                    } else {
                        self.delegate.didRankUser(volunteer: vm.volunteer)
                    }
                    self.updateUI()
                    self.requestReview()
                }
            }
            
        }
        
        func updateUI() {
            statusLabel.text = viewModel.getStatusLabel
            print(viewModel.raitingNumber)
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
        
        
        @IBAction func goToFacebookPressed(_ sender: Any) {
            
            let url = viewModel.profileURL
            print("go to fb pressed \(url)")
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
            
        }
        
        
    }
    
