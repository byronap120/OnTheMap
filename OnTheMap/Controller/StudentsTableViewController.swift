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
    
    @IBAction func userLogOut(_ sender: Any) {
        UdacityAPI.userLogOut(completionHandler: handleUserLogOut(success:error:))
    }
    
    private func handleUserLogOut(success: Bool, error: Error?) {
        if (error != nil) {
            showAlertMessage(title: "Error", message: "Error login out user")
            return
        }
        self.navigationController?.dismiss(animated: true, completion: nil)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = SessionManager.studentsLocation[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        launchSafariWith(url: studentLocation.mediaURL)
    }
}
