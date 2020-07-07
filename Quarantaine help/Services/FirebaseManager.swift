//
//  FirebaseManager.swift
//  Quarantaine help
//
//  Created by Tymoteusz Pasieka on 17/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import CodableFirebase


struct Resource<T: Codable> {
    let ref: DatabaseReference
    init(for path: String) {
        self.ref = Database.database().reference().child(path)
    }
}


enum NetworkError: Error {
    case domainError
    case decodingError
    case connectionError
    case firebaseError
}

struct FirebaseManager {
    private let ref: DatabaseReference! = Database.database().reference()
    private var volunteerRef: DatabaseReference! {
        return ref.child(K.UserFirebaseKeys.users)
    }
    

    
    func getFirabseUid() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    func logInUser(completion: @escaping (Error?) -> Void) {
        if Auth.auth().currentUser == nil {
                        print("user user not login")
                       Auth.auth().signInAnonymously { (authResult, error) in
                        print("user user start login")
                        guard let _ = authResult?.user else { completion(error!); return}
                          print("user user login success")
                        completion(nil)
                        }
        } else {
              print("user user login")
            completion(nil)
        }
    }

    
    func fetchFromFirebase<T: Codable>(resource: Resource<T>, completion: @escaping (Result<[T], NetworkError>)-> Void) {
        resource.ref.observeSingleEvent(of: .value) { (snapshot) in
            if let snap = snapshot.value as? [String: Any] {
                let res: [T] = snap.compactMap({
                    print($0.value)
                    do {
                       let result = try FirebaseDecoder().decode(T.self, from: $0.value)
                        return result
                    } catch {
                        print(error)
                        return nil
                    }
                })
                completion(.success(res))
            } else {
                completion(.failure(.firebaseError))
            }
        }
    }
    
    func addNewVolunteer<T: Codable>(resource: Resource<T>, volunteer: T, id: String) {
        if let decodedVolunteer = try? FirebaseEncoder().encode(volunteer) {
            resource.ref.child(id).setValue(decodedVolunteer)
        }
        
    }

    
    
    func removeVolunteer(id: String) {
            volunteerRef.child(id).removeValue()
    }
}


