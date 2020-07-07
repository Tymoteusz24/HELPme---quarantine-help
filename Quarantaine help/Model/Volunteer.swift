//
//  Volunteer.swift
//  Quarantaine help
//
//  Created by Tymoteusz Pasieka on 17/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation
import MapKit
import FBSDKLoginKit



struct Volunteer: Codable {
    let id: String
    let name: String
    let facebookProfile: String
    let fbPictureURL: String
    let coordinates : VolunteerCoordinates
    var kindOfHelp: [String]
    var rate: [Double]
    
    
    
    var averageRaiting: Double {
        guard self.rate.count > 1 else { return 0.0 }
        return self.rate.reduce(0, +)/Double(self.rate.count - 1)
    }
    
    
    init(from profile: Profile, coordinates: VolunteerCoordinates, kindOfHelp: [KindOfHelp]) {
        
        self.name = profile.firstName ?? ""
        self.facebookProfile = ("\(profile.linkURL!)")
        self.fbPictureURL = "\(profile.imageURL(forMode: .normal, size: CGSize(width: 60, height: 60))!)"
        self.coordinates = coordinates
        self.kindOfHelp = kindOfHelp.map{$0.rawValue}
        self.rate = [0.0]
        self.id = profile.userID
    }
}

struct VolunteerCoordinates: Codable {
    let lat: Double
    let long: Double
}

enum KindOfHelp: String, CaseIterable {
    case buyMedicines
    case doGrocceries
    case walkADog
    case chat
}
