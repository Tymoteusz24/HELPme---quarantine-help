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
        
        showSpinner(onView: self.view)
        mapView.delegate = self
        addVButton.isHidden = false
        profileBarItem.isEnabled = false
        
        // remove after testst
        UserDefaults.standard.set([], forKey: K.UserDefaults.raitings)
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
    
    
    @IBAction func shareBtnTapped(_ sender: Any) {
        shareApp()
    }
    
    
    @IBAction func addVButtonTapped(_ sender: UIButton) {
        
        let storyborard = UIStoryboard(name: "Main", bundle: nil)
        let addVC = storyborard.instantiateViewController(identifier: K.StoryboardIdentifiers.addVolunteerController) as AddVolunteerVC
        
        if let location = locationManager.location?.coordinate {
            addVC.viewModel = AddVolunteerViewModel(coordinates: VolunteerCoordinates(lat: location.latitude, long: location.longitude))
            addVC.viewModel.delegate = self
             self.present(addVC, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func profileBarItemTapperd(_ sender: UIBarButtonItem) {
        
        guard let volunteerProfile = mapControllerViewModel.currentUserProfile else {
            fatalError("no user profile")
        }
        
        guard let vc = storyboard?.instantiateViewController(identifier: K.StoryboardIdentifiers.profileVC, creator: { coder in
             return ProfileVC(coder: coder, viewModel: CurrentVolunteerProfileViewModel(volunteer: volunteerProfile), delegate: self)
         }) else {
             fatalError("Failed to load EditUserViewController from storyboard.")
         }
         
         self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

//MARK: - Custom Delegates

extension MapVC: FirebaseManagerDelegate {
    func addNewVolunteer(volunteer: Volunteer) {
        mapControllerViewModel.volunteerList.append(volunteer)
        mapControllerViewModel.isUserAVolunteer = true
        updateUI()
        print("newVolunteerAdded: \(volunteer)")
    }
    
    
}

extension MapVC: VolunteerProfileVCDelegate , ProfileVCDelegate {
    func didEditProfile(for volunteer: Volunteer) {
        if let row = mapControllerViewModel.volunteerList.firstIndex(where: {$0.id == volunteer.id}) {
                   mapControllerViewModel.volunteerList[row] = volunteer
        }
        
        print("edidter profile")
    }
    
    func didLogOut(for volunteer: Volunteer) {
        if let row = mapControllerViewModel.volunteerList.firstIndex(where: {$0.id == volunteer.id}) {
            mapControllerViewModel.isUserAVolunteer = false
            mapControllerViewModel.volunteerList.remove(at: row)
        }
        print("logout")
    }
    
    func didRankUser(volunteer: Volunteer) {
        if let row = mapControllerViewModel.volunteerList.firstIndex(where: {$0.id == volunteer.id}) {
            mapControllerViewModel.volunteerList[row] = volunteer
            updateUI()
        }
        
    }
    
    
}


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

            guard let vc = storyboard?.instantiateViewController(identifier: K.StoryboardIdentifiers.volunteerProfileVC, creator: { coder in
                return VolunteerProfileVC(coder: coder, viewModel: VolunteerProfileViewModel(volunteer: pin.volunteer), delegate: self)
            }) else {
                fatalError("Failed to load EditUserViewController from storyboard.")
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
     func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}
