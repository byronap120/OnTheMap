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
    @IBOutlet weak var signUpLabel: UITextView!
    
    private let signUpLink = "https://auth.udacity.com/sign-up"
    private let signUpText = "Don't have an account? Sign Up"
    private let linkText = "Sign Up"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loaderIndicator.isHidden = true
        configureSignUpLink()
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
        setLoaderIndicator(true)
        UdacityAPI.requestUserSesion(
            username: emailTextField.text ?? "", password: passwordTextField.text ?? "", completionHandler: handlerequestUserSesion(accountId:error:))
    }
    
    private func showLoginFailure(message: String) {
        showAlertMessage(title: "Login Failed", message: message)
        setLoaderIndicator(false)
    }
    
    private func handlerequestUserSesion(accountId: String, error: Error?) {
        if error != nil {
            showLoginFailure(message: error!.localizedDescription)
            return
        }
        UdacityAPI.getUserData(accountId: accountId, completionHandler: handleGetUserData(userData:error:))
    }
    
    private func handleGetUserData(userData: UserData?, error: Error?) {
        if error != nil {
            showLoginFailure(message: error!.localizedDescription)
            return
        }
        
        SessionManager.userData = userData
        setLoaderIndicator(false)
        clearTextViews()
        performSegue(withIdentifier: "completeLogin", sender: nil)
    }
    
    private func clearTextViews(){
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    private func setLoaderIndicator(_ loggingIn: Bool) {
        if loggingIn {
            loaderIndicator.startAnimating()
            loaderIndicator.isHidden = false
        } else {
            loaderIndicator.stopAnimating()
            loaderIndicator.isHidden = true
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
    private func configureSignUpLink(){
        let attributedOriginalText = NSMutableAttributedString(string: signUpText)
        let linkRange = attributedOriginalText.mutableString.range(of: linkText)
        attributedOriginalText.addAttribute(.link, value: signUpLink, range: linkRange)
        signUpLabel.attributedText = attributedOriginalText
        signUpLabel.font = .systemFont(ofSize: 15)
    }
}
