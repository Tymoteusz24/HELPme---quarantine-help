//
//  VolunteerAnnotation.swift
//  Quarantaine help
//
//  Created by Tymoteusz Pasieka on 18/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import UIKit
import MapKit

class VolunteerAnnotation: MKPointAnnotation {
     private(set) var volunteer: Volunteer!
    
    
    
    var imageName: String?
    
    init(volun: Volunteer) {
        super.init()
        self.volunteer = volun
        self.configure()
    }
    
    func configure() {
        print("Configure: \(volunteer.name) \(volunteer.coordinates.lat)")
        self.title = volunteer.name
        self.coordinate = CLLocationCoordinate2D(latitude: volunteer.coordinates.lat, longitude: volunteer.coordinates.long)
    }
    
    func getImage(completion: @escaping (Result< UIImageView, NetworkError>) -> Void) {
        guard let url = URL(string: volunteer.fbPictureURL) else {
            completion(.failure(.domainError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {

                completion(.failure(.domainError))
                return
            }
            DispatchQueue.main.async {
                    if let image = UIImage(data: data!) {
                        let imageView = UIImageView(image: image)
                        imageView.roundImageView(radius: 30)
                        completion(.success(imageView))
                        } else {
                            completion(.failure(.decodingError))
                        }
            }
        
        }.resume()
    }
}

extension UIImageView {
    func roundImageView(radius: CGFloat) {
        self.layer.masksToBounds = true
        layer.cornerRadius = radius
        UIGraphicsBeginImageContext(self.bounds.size)
              layer.render(in: UIGraphicsGetCurrentContext()!)
              let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
              UIGraphicsEndImageContext()
        self.image = roundedImage
    }
}

