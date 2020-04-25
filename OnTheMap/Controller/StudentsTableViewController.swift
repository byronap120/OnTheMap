//
//  StudentsTableViewController.swift
//  OnTheMap
//
//  Created by Byron Ajin on 4/23/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit

class StudentsTableViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var studentsTableView: UITableView!
    
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
        studentsTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SessionManager.studentsLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let student = SessionManager.studentsLocation[(indexPath as NSIndexPath).row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentsCell") as! StudentTableViewCell
        cell.studentName.text = "\(student.firstName) \(student.lastName)"
        cell.studentSocialInfo.text = student.mediaURL
        
        return cell
    }
}
