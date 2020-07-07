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
    }
    
    struct UserDefaults {
        static let raitings = "raitings"
    }
//    
//    struct CoordFirebaseKey {
//          static let lat = "lat"
//          static let long = "long"
//    }
    
    struct StoryboardIdentifiers {
        static let addVolunteerController = "addVolunteerController"
        static let tabBarController = "tabBarController"
        static let volunteerProfileVC = "volunteerProfileVC"
        static let profileVC = "profileVC"
    }
    
}
