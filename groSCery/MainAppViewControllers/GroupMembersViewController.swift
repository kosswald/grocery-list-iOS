//
//  GroupMembersViewController.swift
//  groSCery
//
//  Created by Naman Kedia on 11/21/18.
//  Copyright © 2018 Kristof Osswald. All rights reserved.
//

import UIKit

class GroupMembersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var groupUsers = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        groupUsers = SavedData().groupMembers
        tableView.reloadData()
        NetworkManager().getGroupSubscribers { (success) in
            DispatchQueue.main.async {
                if (success) {
                    self.groupUsers = SavedData().groupMembers
                    self.tableView.reloadData()
                    
                } else {
                    
                }
            }
           
        }
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupMemberCellID", for: indexPath)
        let user = groupUsers[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        return cell
    }


}
