//
//  MapVC.swift
//  Quarantaine help
//
//  Created by Tymoteusz Pasieka on 17/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import FBSDKLoginKit
import StoreKit


class MapVC: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var addVButton: RoundedButton!
    @IBOutlet weak var profileBarItem: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
  
    var chosenVolunteer: Volunteer?
    
    var mapControllerViewModel = MapControllerViewModel(volunteerList: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapControllerViewModel.isUserAVolunteer = false
        showSpinner(onView: self.view)
        mapView.delegate = self
        addVButton.isHidden = false
        profileBarItem.isEnabled = false

    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkLocationServices()
    }
    
    
    
    private func fetchVolunteers() {
        let resource = Resource<Volunteer>(for: K.UserFirebaseKeys.users)
        FirebaseManager().fetchFromFirebase(resource: resource) { [weak self] (result) in
            switch result {
            case .success(let volunteerList):
                print(volunteerList)
                self?.mapControllerViewModel.volunteerList = volunteerList
                DispatchQueue.main.async {
                    self?.removeSpinner()
                    self?.updateUI()
                }
            case .failure(let error):
                self?.removeSpinner()
                print(error)
            }
        }
    }
    
    
    private func updateUI() {
        let isVolunteer = mapControllerViewModel.isUserAVolunteer
            if isVolunteer {
                self.profileBarItem.isEnabled = true
                self.addVButton.isHidden = true
            } else {
                self.addVButton.isHidden = false
                self.profileBarItem.isEnabled = false
            }
            self.populeteVolunteers()
            self.mapView.reloadInputViews()
    }
    
       
       
    
      private func populeteVolunteers() {
           mapView.removeAnnotations(mapView.annotations)
           let annotations = mapControllerViewModel.returnVolunteerAnnotations()
           mapView.addAnnotations(annotations)
       }
    

    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.Segues.addSegue {
            if let addVolunteerVC = segue.destination as? AddVolunteerVC {
               // addVolunteerVC.delegate = self
                checkLocationAuthorization()
                if let location = locationManager.location?.coordinate {
                    print("\(location)")
                    //addVolunteerVC.coordinates = VolunteerCoordinates(latitude: NSNumber(value: location.latitude), longitude: NSNumber(value: location.longitude))
                }
                
            }
        } else if segue.identifier == K.Segues.toVolunteerProfile {
            if let volunteerProfileVC = segue.destination as? VolunteerProfileVC, let safeVol = chosenVolunteer {
                volunteerProfileVC.volunteer = safeVol
             //   volunteerProfileVC.delegate = self
            }
        } else if segue.identifier == K.Segues.toOwnProfile  {
            if let profileVC = segue.destination as? ProfileVC, let safeVol = chosenVolunteer {
                profileVC.volunteer = safeVol
              //  profileVC.delegate = self
            }
            
        }
    }
    
    @IBAction func shareBtnTapped(_ sender: Any) {
        shareApp()
    }
    
    
    @IBAction func addVButtonTapped(_ sender: UIButton) {
        
        let storyborard = UIStoryboard(name: "Main", bundle: nil)
        let addVC = storyborard.instantiateViewController(identifier: K.StoryboardIdentifiers.addVolunteerController) as AddVolunteerVC
        
        if let location = locationManager.location?.coordinate {
            print("\(location)")
            addVC.viewModel = AddVolunteerViewModel(coordinates: VolunteerCoordinates(lat: location.latitude, long: location.longitude))
            addVC.viewModel.delegate = self
             self.present(addVC, animated: true, completion: nil)
        }
        
    }
    @IBAction func profileBarItemTapperd(_ sender: UIBarButtonItem) {
//        if let safeVolu = volunteerBrain.getCurrentUserProfile() {
//            chosenVolunteer = safeVolu
//            performSegue(withIdentifier: K.Segues.toOwnProfile, sender: nil)
//        }
//
        
        
//        let loginManager = LoginManager()
//        loginManager.logOut()
        
        print(mapView.annotations)
        
        
    }
    
}

extension MapVC: FirebaseManagerDelegate {
    func addNewVolunteer(volunteer: Volunteer) {
        mapControllerViewModel.volunteerList.append(volunteer)
        mapControllerViewModel.isUserAVolunteer = true
        updateUI()
        print("newVolunteerAdded: \(volunteer)")
    }
    
    
}

////MARK: - Firebase delegate
//
//extension MapVC: FirebaseManagerDelegate, AddVolunteerDelegate, VolunteerProfileVCDelegate, ProvileVCDelegate {
//    func didEditProfile(for volunteer: Volunteer) {
//       // firebaseManager.addNewVolunteer(as: volunteer.returnDict())
//        volunteerBrain.editProfile(with: volunteer)
//        updateUI(register: true)
//
//    }
//
//    func didLogOut(for volunteer: Volunteer) {
//        volunteerBrain.removeVolunteer(for: volunteer)
//        updateUI(register: false)
//    }
//
//
//    func didRankUser(volunteer: Volunteer) {
//      //  firebaseManager.addNewVolunteer(as: volunteer.returnDict())
//        volunteerBrain.editProfile(with: volunteer)
//        updateUI(register: volunteerBrain.isUserProfile())
//
//    }
//
//    func didAddVolunteer(vol: Volunteer) {
//      //  firebaseManager.addNewVolunteer(as: vol.returnDict())
//        volunteerBrain.volunteers.append(vol)
//        updateUI(register: true)
//        print("added volounteer \(vol)")
//        self.requestReview()
//    }
//
//    func didFailFetchData() {
//        self.removeSpinner()
//    }
//
//    func didFetchDataFromFirebase(data: [Volunteer]) {
//        self.volunteerBrain.volunteers = data
//        DispatchQueue.main.async {
//            self.updateUI(register: self.volunteerBrain.isUserProfile() )
//            self.removeSpinner()
//        }
//
//        self.requestReview()
//    }
//
//
//
//}
//


//MARK: -  CLLocation and Mapkit delegate

extension MapVC: CLLocationManagerDelegate {
    
    private func setupLocationManager() {
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
       }
       
      private func centerViewOnUserLocation() {
           if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: mapControllerViewModel.regionInMeters, longitudinalMeters: mapControllerViewModel.regionInMeters)
               mapView.setRegion(region, animated: true)
           }
       }
    
   private func checkLocationAuthorization() {
       switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
           //locationManager.startUpdatingLocation()
            fetchVolunteers()
            break
        case .denied:
            //show alert how to turn on permission
            break
        case .notDetermined:
    
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            //show alert whatsup
            break
        case .authorizedAlways:
            break
            
        @unknown default:
            print("error")
            break
        }
    }

   private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            //alert, no location enabled
        }
    }
    
     func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "AnnotationView")
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier:  "AnnotationView")
        } else {
            annotationView?.annotation = annotation
        }


        if let pin = annotationView?.annotation as? VolunteerAnnotation {

            pin.getImage { (result) in
                switch result {
                case .success(let imageView):
                    annotationView?.image = imageView.image
                case .failure(let error):
                    print("image failure \(error)")
                }
                annotationView?.canShowCallout = true
            }
            return annotationView
        }
        return annotationView
       
    }

    
     func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation { return }
        
        if let pin = view.annotation as? VolunteerAnnotation  {

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: K.StoryboardIdentifiers.volunteerProfileVC) as VolunteerProfileVC
            vc.volunteer = pin.volunteer
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
     func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
