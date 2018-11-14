//
//  JoinGroupViewController.swift
//  groSCery
//
//  Created by Naman Kedia on 11/11/18.
//  Copyright © 2018 Kristof Osswald. All rights reserved.
//

import UIKit

class JoinGroupViewController: UIViewController {

    @IBOutlet weak var groupIDTextField: UITextField!
    
    @IBAction func submitJoinGroup(_ sender: Any) {
        if groupIDTextField.text != "" {
            if let groupID = Int(groupIDTextField.text!) {
                NetworkManager().subscribeUserToGroup(groupID: groupID) { (success) in
                    DispatchQueue.main.async {
                        if (success) {
                            let user = SavedData().currentUser
                            user.groupID = groupID
                            SavedData().currentUser = user
//                            SavedData().currentUser.groupID = groupID
                            NetworkManager().parseAllGroceryLists(completion: { (success) in
                                DispatchQueue.main.async {
                                    self.performSegue(withIdentifier: "JoinGroupToGroceryListSegueID", sender: nil)
                                }
                            })
                        } else {
                            let alert = UIAlertController(title: "Error", message: "Unable to join group.", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                   
                }
            }
        } else {
            let alert = UIAlertController(title: "Invalid Group ID", message: "Please enter group ID.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
