//
//  Item.swift
//  groSCery
//
//  Created by Naman Kedia on 10/28/18.
//  Copyright © 2018 Kristof Osswald. All rights reserved.
//

import Foundation

class Item {
    var inStock: Bool
    var name: String
    var suscribedUsers: [String]
    
    init(inStock: Bool, name: String, suscribedUsers: [String]) {
        self.inStock = inStock
        self.name = name
        self.suscribedUsers = suscribedUsers
    }
}
