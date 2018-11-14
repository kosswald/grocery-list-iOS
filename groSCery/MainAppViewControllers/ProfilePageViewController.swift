//
//  ProfilePageViewController.swift
//  groSCery
//
//  Created by Naman Kedia on 11/11/18.
//  Copyright © 2018 Kristof Osswald. All rights reserved.
//

import UIKit

class ProfilePageViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var groupIDLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let user = SavedData().currentUser
        nameLabel.text = "Name: \(user.name)"
        emailLabel.text = "Email: \(user.email)"
        if let groupID = user.groupID {
            groupIDLabel.text = "Group ID: \(groupID)"
        } else {
            groupIDLabel.text = "Group ID: NA"
        }
        

        // Do any additional setup after loading the view.
    }

    @IBAction func logoutButtonClicked(_ sender: Any) {
    }
}
