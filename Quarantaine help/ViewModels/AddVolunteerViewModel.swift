//
//  AddVolunteerViewModel.swift
//  Quarantaine help
//
//  Created by Tymoteusz Pasieka on 06/07/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation
import FBSDKLoginKit

protocol FirebaseManagerDelegate {
    func addNewVolunteer(volunteer: Volunteer)
}


struct AddVolunteerViewModel {
    var kindOfHelps: [KindOfHelp] = []
    var coordinates: VolunteerCoordinates
    var viewState: AddVolunteerViewState = .addTypeOfHelp
    var firebaseManager = FirebaseManager()
    var delegate: FirebaseManagerDelegate?
    
}



extension AddVolunteerViewModel {
    var privacyText: String {
       return NSLocalizedString("We will only display your name and facebook profile so that you can be contacted via Facebook.", comment: "We will only display your name and profile link so that you can be contacted via Facebook.")
    }
    
    func messageLabel() -> String {
        switch viewState {
        case .addTypeOfHelp:
           return  NSLocalizedString("For security reasons, please log in using Facebook. This will allow potentially vulnerable people to make sure that you act in good faith.", comment: "For security reasons, please log in using Facebook. This will allow potentially vulnerable people to make sure that you act in good faith.")
        case .facebookLogIn:
             return  NSLocalizedString("For security reasons, please log in using Facebook. This will allow potentially vulnerable people to make sure that you act in good faith.", comment: "For security reasons, please log in using Facebook. This will allow potentially vulnerable people to make sure that you act in good faith.")
        case .backToMap:
            return NSLocalizedString("You are awesome, thank you for your willingness to help in these difficult times❤️❤️❤️", comment: "You are awesome, thank you for your willingness to help in these difficult times❤️❤️❤️")
        }
    }
    
    mutating func updateKindOfHelp(_ element: KindOfHelp, remove: (_ remove: Bool) -> Void) {
        print("kind \(element)")
        if kindOfHelps.contains(element) {
            removeKindOfHelp(element)
            remove(true)
        }  else {
            kindOfHelps.append(element)
            remove(false)
        }
    }
    
    mutating func removeKindOfHelp(_ element: KindOfHelp) {
         if let index = kindOfHelps.firstIndex(of: element) {
             kindOfHelps.remove(at: index)
         }
     }
    
    func addNewVolunteer(for profile: Profile) {
        let volunteer = Volunteer(from: profile, coordinates: coordinates, kindOfHelp: kindOfHelps)
        
        let resource =  Resource<Volunteer>(for: K.UserFirebaseKeys.users)
        firebaseManager.addNewVolunteer(resource: resource, volunteer: volunteer)
        
        delegate?.addNewVolunteer(volunteer: volunteer)
    }
    
}


enum AddVolunteerViewState {
    case addTypeOfHelp
    case facebookLogIn
    case backToMap
}
