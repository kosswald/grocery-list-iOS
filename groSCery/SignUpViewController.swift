//
//  SignUpViewController.swift
//  groSCery
//
//  Created by Naman Kedia on 11/11/18.
//  Copyright © 2018 Kristof Osswald. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
        
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        
        if (emailTextField.text == "") {
            // show alert
            let alert = UIAlertController(title: "No Email", message: "Please enter your email", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if (nameTextField.text == "") {
            // show alert
            let alert = UIAlertController(title: "No Name", message: "Please enter your name", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if (passwordTextField.text == "") {
            // show alert
            let alert = UIAlertController(title: "No Password", message: "Please enter your password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if (confirmPasswordTextField.text == "") {
            // show alert
            let alert = UIAlertController(title: "Confirm Password", message: "Please confirm your password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if (passwordTextField.text != confirmPasswordTextField.text) {
            let alert = UIAlertController(title: "Inconsistent Passwords", message: "Passwords don't match.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            
            NetworkManager().registerUser(name: nameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!) { (success, accessToken) in
                DispatchQueue.main.async {
                    if (success) {
                        SavedData().accessToken = accessToken
                        print("Sign up worked!!!!!")
                        print(accessToken)
                        
                        self.performSegue(withIdentifier: "SignupToGroupPageID", sender: nil)
                        
                    } else {
                        let alert = UIAlertController(title: "Sign Up Error", message: "User already exists.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
               
            }
        }
    }
    

}
