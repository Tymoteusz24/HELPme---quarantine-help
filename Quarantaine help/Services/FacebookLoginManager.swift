//
//  FacebookLoginManager.swift
//  Quarantaine help
//
//  Created by Tymoteusz Pasieka on 06/07/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

struct FacebookLoginManager {
    private let loginManager = LoginManager()
    
    var currentProfile: Profile? {
        return Profile.current
    }
    
    
    
    func performFacebookLogin(from vc: UIViewController, completion: @escaping (Result<Profile, Error>) -> Void) {
        loginManager.logIn(permissions: ["user_link"], from: vc) { (result, error) in
            guard error == nil else {
                completion(.failure(error!))
                return
            }
           
            guard let result = result, !result.isCancelled else {
                completion(.failure(FacebookError.canceleled))
                return
            }
            
            Profile.loadCurrentProfile { (profile, error) in
                guard error == nil else  {
                    completion(.failure(FacebookError.failLoadProfile))
                    return
                }
                completion(.success(profile!))
                return
            }
            
        }
        
    }
    
    func logOut() {
        loginManager.logOut()
    }
    
    

    
}

enum FacebookError: Error {
    case canceleled
    case failLoadProfile
}
