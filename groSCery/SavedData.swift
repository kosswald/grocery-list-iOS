//
//  Data.swift
//  groSCery
//
//  Created by Naman Kedia on 11/11/18.
//  Copyright © 2018 Kristof Osswald. All rights reserved.
//

import Foundation

class SavedData {
    
    var loggedIn: Bool {
        get {
            if let loggedIn = UserDefaults.standard.value(forKey: "loggedInKey") as? Bool {
                return loggedIn
            } else {
                return false
            }
        } set {
            UserDefaults.standard.set(newValue, forKey: "loggedInKey")
        }

    }
    
    var accessToken: String {
        get {
            if let accessToken = UserDefaults.standard.value(forKey: "accessTokenKey") as? String {
                return accessToken
            } else {
                return "NA"
            }
        } set {
            UserDefaults.standard.set(newValue, forKey: "accessTokenKey")
        }
    }
    
    
    var allGroupItems: [Item] {
        set {
            let encoder = JSONEncoder()
            if let encodedLocations = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encodedLocations, forKey: "allGroupItemsKey")
            }
            
        } get {
            if let itemData = UserDefaults.standard.value(forKey: "allGroupItemsKey") as? Data {
                let decoder = JSONDecoder()
                if let items = try? decoder.decode(Array.self, from: itemData) as [Item] {
                    return items
                }
            }
            
            return [Item]()
            
        }
    }
    
    var suscribedItems: [Item] {
        set {
            let encoder = JSONEncoder()
            if let encodedLocations = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encodedLocations, forKey: "suscribedItemsKey")
            }
            
        } get {
            if let itemData = UserDefaults.standard.value(forKey: "suscribedItemsKey") as? Data {
                let decoder = JSONDecoder()
                if let items = try? decoder.decode(Array.self, from: itemData) as [Item] {
                    return items
                }
            }
            
            return [Item]()
        }
    }
    
    var unsuscribedItems: [Item] {
        set {
            let encoder = JSONEncoder()
            if let encodedLocations = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encodedLocations, forKey: "unsuscribedItemsKey")
            }
            
        } get {
            if let itemData = UserDefaults.standard.value(forKey: "unsuscribedItemsKey") as? Data {
                let decoder = JSONDecoder()
                if let items = try? decoder.decode(Array.self, from: itemData) as [Item] {
                    return items
                }
            }
            return [Item]()
        }
    }
    
    var inStockItems: [Item] {
        set {
            let encoder = JSONEncoder()
            if let encodedLocations = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encodedLocations, forKey: "inStockItemsKey")
            }
            
        } get {
            if let itemData = UserDefaults.standard.value(forKey: "inStockItemsKey") as? Data {
                let decoder = JSONDecoder()
                if let items = try? decoder.decode(Array.self, from: itemData) as [Item] {
                    return items
                }
            }
            return [Item]()
        }
    }
    
    var outOfStockItems: [Item] {
        set {
            let encoder = JSONEncoder()
            if let encodedLocations = try? encoder.encode(newValue) {
                UserDefaults.standard.set(encodedLocations, forKey: "outOfStockItemsKey")
            }
            
        } get {
            if let itemData = UserDefaults.standard.value(forKey: "outOfStockItemsKey") as? Data {
                let decoder = JSONDecoder()
                if let items = try? decoder.decode(Array.self, from: itemData) as [Item] {
                    return items
                }
            }
            return [Item]()
        }
    }
    
    var currentUser: User {
        set {
            let encoder = JSONEncoder()
            if let user = try? encoder.encode(newValue) {
                UserDefaults.standard.set(user, forKey: "currentUserKey")
            }
        } get {
            if let userData = UserDefaults.standard.value(forKey: "currentUserKey") as? Data {
                let decoder = JSONDecoder()
                if let user = try? decoder.decode(User.self, from: userData) as User {
                    return user
                }
            }
            return User(email: "", name: "", groupID: "")
        }
    }
    
 

}
