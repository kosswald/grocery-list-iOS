//
//  LoginViewController.swift
//  groSCery
//
//  Created by Naman Kedia on 11/11/18.
//  Copyright © 2018 Kristof Osswald. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        emailTextField.text = "osswald@usc.edu"
        passwordTextField.text = "password"
    }
    
    @IBAction func submitLogin(_ sender: Any) {
        if (emailTextField.text == "") {
            // show alert
            let alert = UIAlertController(title: "No Email", message: "Please enter your email", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if (passwordTextField.text == "") {
            // show alert
            let alert = UIAlertController(title: "No Password", message: "Please enter your password", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            NetworkManager().loginUser(email: emailTextField.text!, password: passwordTextField.text!) { (success, accessToken) in
                DispatchQueue.main.async {
                    if (success) {
                        print(accessToken)
                        SavedData().accessToken = accessToken
                        SavedData().loggedIn = true
                        NetworkManager().getUserDetails(completion: { (success) in
                            if SavedData().currentUser.groupID == nil {
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "LoginToCreateJoinGroupSegueID", sender: nil)
                                }
                            } else {
                                NetworkManager().parseAllGroceryLists(completion: { (success) in
                                    DispatchQueue.main.async {
                                        if (success) {
                                            self.performSegue(withIdentifier: "LoginToGroceryListSegueID", sender: nil)
                                        }
                                    }
                                })
                            }
                            
                            
                            
                           
                        })
                        
                    } else {
                        let alert = UIAlertController(title: "Incorrect", message: "Username or password is incorrect. Try again.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.isSecureTextEntry = true
    }
    

}
