//
//  SignUpSignInViewController.swift
//  Job Application Tracker
//
//  Created by Jake Connerly on 3/18/20.
//  Copyright © 2020 jake connerly. All rights reserved.
//

import UIKit

class SignUpSignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func alreadyHaveAccountButtonTapped(_ sender: UIButton) {
    }
}
