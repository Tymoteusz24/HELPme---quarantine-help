//
//  MapControllerViewModel.swift
//  Quarantaine help
//
//  Created by Tymoteusz Pasieka on 03/07/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation
import MapKit

struct MapControllerViewModel {
    var volunteerList: [Volunteer]
    
    init(volunteerList: [Volunteer]) {
        self.volunteerList = volunteerList
    }
    
    private var _isUserAVolunteer = false
    
    var regionInMeters: Double = 9000000
    
    func returnVolunteerAnnotations() -> [VolunteerAnnotation] {
        let arrayToReturn: [VolunteerAnnotation] = volunteerList.map({
            let annotation = VolunteerAnnotation(volun: $0)
            return annotation
        })
        return arrayToReturn
    }
    


    
}


extension MapControllerViewModel {

  
    
    var isUserAVolunteer: Bool {
        get {
            let userDefaults = UserDefaults.standard
            if userDefaults.bool(forKey: "isVolunteer") {
                return true
            } else {
                return _isUserAVolunteer
            }
        }
        set {
              let userDefaults = UserDefaults.standard
            userDefaults.set(newValue, forKey: "isVolunteer")
            _isUserAVolunteer = newValue
        }
    }
}
