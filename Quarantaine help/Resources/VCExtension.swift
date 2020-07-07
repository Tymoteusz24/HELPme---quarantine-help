//
//  VCExtension.swift
//  Quarantaine help
//
//  Created by Tymoteusz Pasieka on 18/03/2020.
//  Copyright © 2020 Tymoteusz Pasieka. All rights reserved.
//

import Foundation
import UIKit
import  StoreKit


var vSpinner : UIView?

extension UIViewController {
    
    
    
    func createOKAlert (title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func createYesNoAlert(title: String, message: String, completionHandler: @escaping ((_ yes: Bool)->Void)) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Yes"), style: .default, handler: { (action: UIAlertAction!) in
            completionHandler(true)
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("No", comment: "No"), style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
            completionHandler(false)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - spinner for fetching data
    
    func showSpinner(onView : UIView) {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(style: .large)
        ai.startAnimating()
        ai.center = spinnerView.center
        
        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }
        
        vSpinner = spinnerView
    }
    
    func removeSpinner() {
        DispatchQueue.main.async {
            vSpinner?.removeFromSuperview()
            vSpinner = nil
        }
    }
    
    
    func requestReview() {
        if AppStoreReviewManager.requestReviewIfAppropriate() {
            createYesNoAlert(title: NSLocalizedString("Please rate the app", comment: "Please rate the app"), message: NSLocalizedString("Do you want to rate the App. This will help other find help.", comment: "Do you want to rate the App. This will help other find help. ")) { (confirm) in
                if confirm {
                    SKStoreReviewController.requestReview()
                }
            }
        }
        
    }
    
    func shareApp () {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let textToShare = NSLocalizedString("Please help people during epidemic", comment: "Please help people during epidemic")
        
        if let myWebsite = URL(string: "http://itunes.apple.com/app/id1503485591") {//Enter link to your app here
            let objectsToShare = [textToShare, myWebsite, image ?? #imageLiteral(resourceName: "app-logo")] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            //Excluded Activities
            activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]
            //
            
            
            
            activityVC.popoverPresentationController?.sourceView = self.view
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
}
