//
//  Contstants.swift
//  Quarantaine help
//
//  Created by Tymoteusz Pasieka on 17/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation
import  UIKit


struct K {
    
    struct Colors {
        static let bordo: UIColor = #colorLiteral(red: 0.6509803922, green: 0.01176470588, blue: 0.1843137255, alpha: 1)
    }
    struct UserFirebaseKeys {
        static let users = "users"
       static let firebaseID = "firebaseID"
        static let startedChats = "startedChats"
        static let name = "name"
        static let facebookProfile = "facebookProfile"
        static let coordinates = "coordinates"
        static let kindOfHelp = "kindOfHelp"
        static let rate = "rate"
        static let busy = "busy"
        static let fbPictureURL = "fbPictureURL"
    }
    
    struct MessageFirebaseKey {
        static let timestamp = "timestamp"
        static let message = "message"
        static let userId = "userId"
    }
    
    struct CoordFirebaseKey {
          static let lat = "lat"
          static let long = "long"
    }
    
    struct Segues {
        static let addSegue = "addSegue"
        static let toVolunteerProfile = "toVolunteerProfile"
        static let toOwnProfile = "toOwnProfile"
    }
    struct StoryboardIdentifiers {
        static let addVolunteerController = "addVolunteerController"
        static let tabBarController = "tabBarController"
        static let volunteerProfileVC = "volunteerProfileVC"
    }
    
}
