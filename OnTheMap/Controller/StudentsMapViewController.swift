//
//  StudentsMapViewController.swift
//  OnTheMap
//
//  Created by Byron Ajin on 4/23/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit
import MapKit

class StudentsMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStudentsLocation()
    }
    
    @IBAction func refreshStudentsLocation(_ sender: Any) {
         getStudentsLocation()
    }

    private func getStudentsLocation(){
        UdacityAPI.getStudentLocation(completionHandler: handleGetStudentLocation(studentsLocation:error:))
    }
    
    private func handleGetStudentLocation(studentsLocation: [StudentLocation]?, error: Error?) {
        if error != nil {
            showAlertMessage(title: "Error", message: "Error loading students locations")
            return
        }
        SessionManager.studentsLocation = studentsLocation!
        
        var annotations = [MKPointAnnotation]()
        for student in studentsLocation! {
            
            let lat = CLLocationDegrees(student.latitude)
            let long = CLLocationDegrees(student.longitude)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaURL
            
            annotations.append(annotation)
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotations(annotations)
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
