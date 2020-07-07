//
//  VolunteerProfileViewModel.swift
//  Quarantaine help
//
//  Created by Tymoteusz Pasieka on 07/07/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation

//MARK: - VolunteerProfileProtcol

protocol VolunteerProfileProtocol {
    var volunteer: Volunteer { get }
    var getStatusLabel: String {get}
    
    var raitingLabel: String {get}
    var raitingNumber: Double {get}
    
    var profileURL: URL {get}
    
    func returnKindOfHelps(kindOfHelp: (KindOfHelp)->Void)
}

//MARK: - Default implementation

extension VolunteerProfileProtocol {
    var profileURL: URL {
           return URL(string: self.volunteer.facebookProfile)!
    }
    
    var getStatusLabel: String {
          return volunteer.name + NSLocalizedString(" is ready to help!", comment: " is ready to help!")
      }
    
     var raitingLabel: String {
         guard volunteer.rate.count > 1 else {
              return "No raiting"
         }
         return String(format: "%.1f", volunteer.averageRaiting) + "( \(volunteer.rate.count - 1))"
     }
     
     var raitingNumber: Double {
         return volunteer.averageRaiting
     }
    
    func returnKindOfHelps(kindOfHelp: (KindOfHelp) -> Void) {
         for help in volunteer.kindOfHelp {
             kindOfHelp(KindOfHelp(rawValue: help)!)
         }
     }
    
    
}

//MARK: - Volunteer Profile View Model

class VolunteerProfileViewModel: VolunteerProfileProtocol {
    private var _volunteer: Volunteer

    
    var volunteer: Volunteer {
           return _volunteer
           }
    
    
    init(volunteer: Volunteer) {
        self._volunteer = volunteer
    }
    
}


//MARK: - Cosmos view

extension VolunteerProfileViewModel {
    
    func rateUser(rate: Double, alreadyRated: (Bool)->Void) {
        let defaults = UserDefaults.standard
        var raitingsArray = defaults.array(forKey: K.UserDefaults.raitings) as? [String] ?? []
        if raitingsArray.contains(volunteer.id) {
            alreadyRated(true)
        } else {
            self._volunteer.rate.append(rate)
            
            raitingsArray.append(volunteer.id)
            defaults.set(raitingsArray, forKey: K.UserDefaults.raitings)
            
            let resource = Resource<Volunteer>(for: K.UserFirebaseKeys.users)
            FirebaseManager().addNewVolunteer(resource: resource, volunteer: self._volunteer, id: self._volunteer.id)
            
            alreadyRated(false)
        }
    }

    
    func checkIfAlreadyRated() -> Bool {
        let defaults = UserDefaults.standard
        let raitingsArray = defaults.array(forKey: K.UserDefaults.raitings) as! [String]
        let isRated = raitingsArray.contains(volunteer.id) ?  true :  false
        return isRated
    }
}


//MARK: - CurrentVolunteerProfileViewModel


class CurrentVolunteerProfileViewModel: VolunteerProfileProtocol {
     private var _volunteer: Volunteer

       
       var volunteer: Volunteer {
              return _volunteer
              }
       
        private(set) var kindOfHelps: [KindOfHelp]
       
       init(volunteer: Volunteer) {
        self._volunteer = volunteer
        self.kindOfHelps = volunteer.kindOfHelp.map({KindOfHelp(rawValue: $0)!})
        
       }
    
}

extension CurrentVolunteerProfileViewModel {
     func updateKindOfHelp(_ element: KindOfHelp, remove: (_ remove: Bool) -> Void) {
          print("kind \(element)")
          if kindOfHelps.contains(element) {
              removeKindOfHelp(element)
              remove(true)
          }  else {
              kindOfHelps.append(element)
              remove(false)
          }
        self._volunteer.kindOfHelp = kindOfHelps.map({"\($0)"})
      }
      
       func removeKindOfHelp(_ element: KindOfHelp) {
           if let index = kindOfHelps.firstIndex(of: element) {
               kindOfHelps.remove(at: index)
           }
       }
}

