//
//  CreateGroupViewController.swift
//  groSCery
//
//  Created by Naman Kedia on 11/11/18.
//  Copyright © 2018 Kristof Osswald. All rights reserved.
//

import UIKit

class CreateGroupViewController: UIViewController {

    @IBOutlet weak var groupName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func submitCreateGroup(_ sender: Any) {
        if (groupName.text != "") {
            
            NetworkManager().createNewGroup(name: groupName.text!) { (success, groupID) in
                DispatchQueue.main.async {
                    if (success) {
                        print(groupID)
                        self.performSegue(withIdentifier: "CreateGroupToListSegueID", sender: nil)
                    } else {
                        let alert = UIAlertController(title: "Error.", message: "Unable to create group.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
               
            }
            
        } else {
            let alert = UIAlertController(title: "No Group Name.", message: "Please enter a group name.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    

}
