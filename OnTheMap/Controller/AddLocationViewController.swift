//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Byron Ajin on 4/24/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class AddLocationViewController: UIViewController {
    
    @IBOutlet weak var userLocation: UITextField!
    @IBOutlet weak var userMediaURL: UITextField!
    @IBOutlet weak var loaderIndicator: UIActivityIndicatorView!
    @IBOutlet weak var locationButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loaderIndicator.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addLocationMap" {
            let addLocationMapViewController = segue.destination as! AddLocationMapViewController
            let location = sender as! CLLocationCoordinate2D
            addLocationMapViewController.location = location
            addLocationMapViewController.mediaUrl = userMediaURL.text!
            addLocationMapViewController.userLocation = userLocation.text!
        }
    }
    
    @IBAction func findUserLocation(_ sender: Any) {
        self.setLoaderIndicator(true)
        if (userMediaURL.text!.isEmpty) {
            self.showAlertMessage(title: "Error", message: "Media URL cannot be empty")
            return
        }
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(userLocation.text!) { (placemarks: [CLPlacemark]?, error: Error?) in
            if error != nil || placemarks == nil || placemarks!.count == 0{
                self.showAlertMessage(title: "Error", message: "Location not found")
                return
            }
            let topLocation = placemarks?.first
            let location: CLLocationCoordinate2D = (topLocation?.location?.coordinate)!
            self.setLoaderIndicator(false)
            self.performSegue(withIdentifier: "addLocationMap", sender: location)
        }
    }
    
    @IBAction func cancelAddLocation(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    private func setLoaderIndicator(_ loggingIn: Bool) {
        if loggingIn {
            loaderIndicator.startAnimating()
            loaderIndicator.isHidden = false
        } else {
            loaderIndicator.stopAnimating()
            loaderIndicator.isHidden = true
        }
        locationButton.isEnabled = !loggingIn
        userLocation.isEnabled = !loggingIn
        userMediaURL.isEnabled = !loggingIn
    }
    
}
