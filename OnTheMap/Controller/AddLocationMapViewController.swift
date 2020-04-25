//
//  AddLocationMapViewController.swift
//  OnTheMap
//
//  Created by Byron Ajin on 4/24/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit
import MapKit

class AddLocationMapViewController: UIViewController , MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishButton: UIButton!
    
    var location: CLLocationCoordinate2D!
    var mediaUrl: String!
    var userLocation: String!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        var region: MKCoordinateRegion = self.mapView.region
        region.center = location
        region.span.longitudeDelta /= 8.0
        region.span.latitudeDelta /= 8.0
        self.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = userLocation
        annotation.subtitle = mediaUrl
        self.mapView.addAnnotation(annotation)
        self.mapView.selectAnnotation(annotation, animated: true)
    }
        
    @IBAction func postStudentLocation(_ sender: Any) {
        finishButton.isEnabled = false
        UdacityAPI.postStudentLocation(mapString: userLocation, mediaUrl: mediaUrl, latitude: location.latitude, longitude: location.longitude, completionHandler: handlePostStudent(success:error:))
    }
    
    private func handlePostStudent(success: Bool, error: Error?) {
        finishButton.isEnabled = true
        if error != nil {
            showAlertMessage(title: "Error", message: error!.localizedDescription)
            return
        }
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
                
        return pinView
    }
}
