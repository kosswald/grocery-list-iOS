//
//  LoginViewController.swift
//  groSCery
//
//  Created by Kristof Osswald on 10/20/18.
//  Copyright © 2018 Kristof Osswald. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var logoutBtn: GIDSignInButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /** @var handle
     @brief The handler for the auth state listener, to allow cancelling later.
     */
    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if Auth.auth().currentUser != nil {
                print("Logged in")
                
            } else {
                print("Not logged in")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        // ...
    }

    
}

