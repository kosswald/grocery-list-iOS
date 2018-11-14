//
//  InitialViewController.swift
//  groSCery
//
//  Created by Naman Kedia on 11/11/18.
//  Copyright © 2018 Kristof Osswald. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        if (SavedData().loggedIn) {
//            if (SavedData().currentUser.groupID != nil) {
//                performSegue(withIdentifier: "AlreadyLoggedInSegueID", sender: nil)
//            }
//        }
    }
    
    @IBAction func unwindInitialVC(segue:UIStoryboardSegue) {
        SavedData().loggedIn = false
        
    }
    
 
}
