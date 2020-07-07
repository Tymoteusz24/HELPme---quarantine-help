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
    var firebaseID: String {
        return ""
    }
    let name: String
    let facebookProfile: String
    let fbPictureURL: String
    let coordinates : VolunteerCoordinates
    var kindOfHelp: [String]
    var rate: [Double]
    
    
    init(from profile: Profile, coordinates: VolunteerCoordinates, kindOfHelp: [KindOfHelp]) {
        
        
        self.name = profile.firstName ?? ""
        self.facebookProfile = ("\(profile.linkURL!)")
        self.fbPictureURL = "\(profile.imageURL(forMode: .normal, size: CGSize(width: 60, height: 60))!)"
        self.coordinates = coordinates
        self.kindOfHelp = kindOfHelp.map{$0.rawValue}
        self.rate = [0.0]
        
    }
    
//    
//    var roundedLatitude: Double {
//        Double(round(100 * Double(coordinates.lat))/100)
//    }
//    
//    var roundedLongitude: Double {
//        Double(round(100 * Double(coordinates.long))/100)
//    }
    
//    var kindOfKelpArray: [String] {
//        var tempArray = [String]()
//        for kind in kindOfHelp {
//            tempArray.append(kind.rawValue)
//        }
//        return tempArray
//    }
//    
//    init(id: String, n: String, fbProfileID: URL, coord: VolunteerCoordinates, help: [KindOfHelp], pictureUrl: URL) {
//        self.busy = false
//        self.rate = [0.0]
//        self.firebaseID = id
//        self.name = n
//        self.facebookProfileUrl = fbProfileID
//        self.coordinates = coord
//        self.kindOfHelp = help
//        self.fbPictureURL = pictureUrl
//    }
//    
//    init(id: String, dict: [String: Any]) {
//        self.firebaseID = id
//        self.name = dict[K.UserFirebaseKeys.name] as! String
//        self.facebookProfileUrl = URL(string: (dict[K.UserFirebaseKeys.facebookProfile] as! String)) ?? URL(fileURLWithPath: "")
//        self.fbPictureURL = URL(string: (dict[K.UserFirebaseKeys.fbPictureURL]) as! String) ?? URL(fileURLWithPath: "")
//        
//        self.busy = dict[K.UserFirebaseKeys.busy] as! Bool
//        
//        
//        let coordValue = dict[K.UserFirebaseKeys.coordinates] as! [String:Any]
//        self.coordinates = VolunteerCoordinates(dict: coordValue)
//        
//        let rateDict = dict[K.UserFirebaseKeys.rate] as! [NSNumber]
//        var tempRate: [Float] = []
//        for raiting in rateDict {
//            tempRate.append(Float(raiting))
//        }
//        self.rate = tempRate
//        
//        let helpDict = dict[K.UserFirebaseKeys.kindOfHelp] as! [String]
//        
//        var tempHelp: [KindOfHelp] = []
//        for help in helpDict {
//            tempHelp.append(KindOfHelp(rawValue: help)!)
//        }
//        self.kindOfHelp = tempHelp
//    }
//    
//    func returnDict() -> [String: Any] {
//        return [K.UserFirebaseKeys.name : name, K.UserFirebaseKeys.facebookProfile : facebookProfileUrl.absoluteString, K.UserFirebaseKeys.coordinates : coordinates.dict, K.UserFirebaseKeys.rate : rate, K.UserFirebaseKeys.kindOfHelp : kindOfKelpArray , K.UserFirebaseKeys.busy : busy, K.UserFirebaseKeys.fbPictureURL : fbPictureURL.absoluteString]
//    }
    
    
    
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
