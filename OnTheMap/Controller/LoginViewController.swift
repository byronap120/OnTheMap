//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Byron Ajin on 4/18/20.
//  Copyright © 2020 Byron Ajin. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loaderIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        setLoaderIndicator(true)
        UdacityAPI.requestUserSesion(
            username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completionHandler: handlerequestUserSesion(accountId:error:))
    }
    
    func handlerequestUserSesion(accountId: String, error: Error?) {
        if error != nil {
            showLoginFailure(message: error!.localizedDescription)
            return
        }
        UdacityAPI.getUserData(accountId: accountId, completionHandler: handleGetUserData(userData:error:))
    }
    
    func handleGetUserData(userData: UserData?, error: Error?) {
        if error != nil {
            showLoginFailure(message: error!.localizedDescription)
            return
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        var userManager = appDelegate.userManager
        userManager.name = userData?.firstName ?? ""
        userManager.lastName = userData?.lastName ?? ""
        userManager.nickname = userData?.nickname ?? ""
        setLoaderIndicator(false)
        performSegue(withIdentifier: "completeLogin", sender: nil)
    }
    
    private func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
        setLoaderIndicator(false)
    }
    
    private func setLoaderIndicator(_ loggingIn: Bool) {
        if loggingIn {
            loaderIndicator.startAnimating()
        } else {
            loaderIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
}

