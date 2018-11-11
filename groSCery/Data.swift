//
//  Data.swift
//  groSCery
//
//  Created by Naman Kedia on 11/11/18.
//  Copyright © 2018 Kristof Osswald. All rights reserved.
//

import Foundation

struct Data {
    
    var accessToken: String {
        get {
            if let accessToken = UserDefaults.standard.value(forKey: "accessTokenKey") as? String {
                return accessToken
            } else {
                return "NA"
            }
        } set {
            UserDefaults.standard.set(accessToken, forKey: "accessTokenKey")
        }
    }
}
