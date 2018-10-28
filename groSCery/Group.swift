//
//  Group.swift
//  groSCery
//
//  Created by Naman Kedia on 10/28/18.
//  Copyright © 2018 Kristof Osswald. All rights reserved.
//

import Foundation

class Group {
    let groupName: String
    let items: [Item]
    let users: [String]
    
    init(groupName: String, items: [Item], users: [String]) {
        self.groupName = groupName
        self.items = items
        self.users = users
    }
    
}
