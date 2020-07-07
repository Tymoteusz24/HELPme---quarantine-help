//
//  AddVolunteerVC.swift
//  Quarantaine help
//
//  Created by Tymoteusz Pasieka on 17/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

protocol AddVolunteerDelegate {
    func didAddVolunteer(vol: Volunteer)
}

class AddVolunteerVC: UIViewController {
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var loginButton: RoundedButton!
    
    @IBOutlet weak var privacyLabel: UILabel!
    
    @IBOutlet weak var choiceStackView: UIStackView!
    
    var viewModel: AddVolunteerViewModel!
    
    private var kindOfHelps = [KindOfHelp]()
    private var state = 0
    var coordinates: VolunteerCoordinates?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        privacyLabel.text = viewModel.privacyText
        
        updateUI()
    }
    
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func checkmarkButtonTapped(_ sender: UIButton) {
        let selected = sender.isSelected
        print("tag : \(sender.tag)")
        viewModel.updateKindOfHelp(KindOfHelp.allCases[sender.tag]) { (remove: Bool) in
            sender.tintColor = remove ? .lightGray : K.Colors.bordo
            sender.isSelected = !selected
        }
    }
    
    private func performFBLogin() {
        FacebookLoginManager().performFacebookLogin(from: self) { [weak self] (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self?.createOKAlert(title: "Login error", message: "Plesae try again.")
                }
                break
            case . success(let profile):
                self?.viewModel.addNewVolunteer(for: profile)
                self?.viewModel.viewState = .backToMap
                self?.updateUI()
                break
            }
        }
    }
    
    
    
    @IBAction func loginButtonTapped(_ sender: RoundedButton) {
        
        switch viewModel.viewState {
        case .addTypeOfHelp:
            guard viewModel.kindOfHelps.count > 0 else {
                createOKAlert(title: NSLocalizedString("Select help type", comment: "Select help type"), message: NSLocalizedString("You must choose at least one thing.", comment: "You must choose at least one thing."))
                return
            }
            viewModel.viewState = .facebookLogIn
            updateUI()
        case .facebookLogIn:
            performFBLogin()
            break
        case .backToMap:
            self.dismiss(animated: true, completion: nil)
            print("ok")
            
        }
        
    }
    
    
}

//MARK: - Cutomise UI

extension AddVolunteerVC {
    
    func updateUI() {
        
        messageLabel.text = viewModel.messageLabel()
        
        switch viewModel.viewState {
        case .addTypeOfHelp:
            choiceStackView.isHidden = false
            messageLabel.isHidden = true
            privacyLabel.isHidden = true
            loginButton.setTitle(NSLocalizedString("Confirm", comment: "Confirm"), for: .normal)
            break
        case .facebookLogIn:
            choiceStackView.isHidden = true
            messageLabel.isHidden = false
            privacyLabel.isHidden = false
            loginButton.setTitle(NSLocalizedString("Log in 👍🏻", comment: "Log in 👍🏻"), for: .normal)
            break
        case .backToMap:
            choiceStackView.isHidden = true
            messageLabel.isHidden = false
            privacyLabel.isHidden = false
            loginButton.setTitle(NSLocalizedString("Back to map", comment: "Back to map"), for: .normal)
            break
        }
        
        loginButton.isEnabled = true
    }
    
 
}

