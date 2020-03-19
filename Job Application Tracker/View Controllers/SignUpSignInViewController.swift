//
//  SignUpSignInViewController.swift
//  Job Application Tracker
//
//  Created by Jake Connerly on 3/18/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import UIKit

class SignUpSignInViewController: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var signupSigninSegControl: UISegmentedControl!
    
    // MARK: - Properties
    
    var userController: UserController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
 
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        guard let userController = userController,
            let email = emailTextField.text,
            let username = usernameTextField.text,
            let password = passwordTextField.text else { return }
        
        switch signupSigninSegControl.selectedSegmentIndex {
        case 1:
            userController.signInWithEmail(email: email, password: password) {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        default:
            userController.signUpWithEmail(email: email, username: username, password: password) {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }

        }
        
            }
    
    @IBAction func signupSigninDidChangeValue(_ sender: UISegmentedControl) {
        
        switch signupSigninSegControl.selectedSegmentIndex {
        case 1:
            usernameTextField.isHidden = true
            usernameLabel.isHidden = true
            signUpButton.titleLabel?.text = "Sign In"
        default:
            usernameTextField.isHidden = false
            usernameLabel.isHidden = false
            signUpButton.titleLabel?.text = "Sign Up"
        }
    }
    
}
