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
    }

    @IBAction func logoutButtonClicked(_ sender: Any) {
        NetworkManager().logoutUser { (success) in
            DispatchQueue.main.async {
                if (success) {
                    self.performSegue(withIdentifier: "unwindToInitialVCSegueID", sender: nil)
                } else {
                    let alert = UIAlertController(title: "Log out error", message: "Unable to log out.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }
    }
}
