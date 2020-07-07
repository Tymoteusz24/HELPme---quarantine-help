//
//  VolunteerBrain.swift
//  Quarantaine help
//
//  Created by Tymoteusz Pasieka on 17/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation
import FirebaseAuth


struct VolunteerBrain {
    
    var volunteers: [Volunteer] = []
    
    func isUserProfile() -> Bool {
        
        if let userID = Auth.auth().currentUser?.uid {
            let filtered = volunteers.filter{$0.firebaseID == userID}
            let bool = filtered.count == 1 ? true : false
            return bool
        }
        return false
    }
    
    func getCurrentUserProfile() -> Volunteer? {
        if let userID = Auth.auth().currentUser?.uid {
            print("userUid: \(userID), vol: \(volunteers)")
    
            let filtered = volunteers.filter{$0.firebaseID == userID}
            guard filtered.count == 1 else { return nil }
            return filtered[0]
        }
       return nil
    }
    
    private func returnProfileArrayIndex(for volunteer: Volunteer) -> Int? {
        if let userID = Auth.auth().currentUser?.uid {
                   var index = 0
                   for volunteer in volunteers {
                       if volunteer.firebaseID == userID {
                           return index
                       }
                       index += 1
                   }
            }
        return nil
    }
    
    mutating func editProfile(with data: Volunteer) {
        if let index = returnProfileArrayIndex(for: data) {
            volunteers[index] = data
        }
    }
    
    mutating func removeVolunteer(for volunteer: Volunteer) {
        if let index = returnProfileArrayIndex(for: volunteer) {
            volunteers.remove(at: index)
        }
    }
}
