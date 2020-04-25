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
    
    var location: CLLocationCoordinate2D!
    var mediaUrl: String!
    var userLocation: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    @IBAction func postStudentLocation(_ sender: Any) {
        
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
