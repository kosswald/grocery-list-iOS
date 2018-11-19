//
//  NetworkManager.swift
//  groSCery
//
//  Created by Naman Kedia on 11/11/18.
//  Copyright © 2018 Kristof Osswald. All rights reserved.
//

import Foundation

class NetworkManager {
    
    // Groups
    
    func getGroupItems(completion: @escaping(Bool, [Item]) -> Void) {
        let urlPath: String = "https://201.kristofs.app/api/groups/items"
        if let submitURL = URL(string: urlPath) {
            var request = URLRequest(url: submitURL)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let accessTokenBearer = "Bearer " + SavedData().accessToken
            request.setValue(accessTokenBearer, forHTTPHeaderField: "Authorization")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    do {
                        print(data)
                        let dataJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                        var groupItems = [Item]()
                        if let items = dataJSON["success"] as? [[String: Any]] {
                            for item in items {
                                var name = "NA"
                                var inStock = false
                                var id = -1
                                if let itemName = item["name"] as? String {
                                    name = itemName
                                }
                                if let itemInStock = item["in_stock"] as? Bool {
                                    inStock = itemInStock
                                }
                                if let itemID = item["id"] as? Int {
                                    id = itemID
                                }
                                let newItem = Item(inStock: inStock, name: name, suscribedUsers: [], itemID: id)
                                groupItems.append(newItem)
                            }
                            completion(true, groupItems)
                            
                        }
                        print(dataJSON)
                        
                    } catch {
                        completion(false, [])
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    func subscribeUserToGroup(groupID: Int, completion: @escaping(Bool)->Void) {
        let urlPath: String = "https://201.kristofs.app/api/groups/subscribe/\(groupID)"
        if let submitURL = URL(string: urlPath) {
            var request = URLRequest(url: submitURL)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.timeoutInterval = 10
            let accessTokenBearer = "Bearer " + SavedData().accessToken
            request.setValue(accessTokenBearer, forHTTPHeaderField: "Authorization")
            let session = URLSession.shared
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    do {
                        let successJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                        if let _ = successJSON["success"] {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    } catch {
                        completion(false)
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    func createNewGroup(name: String, completion: @escaping (Bool, Int) -> Void) {
        let parameters : [String : Any] = ["name" : name]
        let postString = dictToString(paramaterDict: parameters)
        let postData = postString.data(using: String.Encoding.ascii, allowLossyConversion: true)!
        let urlPath: String = "https://201.kristofs.app/api/groups/create"
        if let submitURL = URL(string: urlPath) {
            var request = URLRequest(url: submitURL)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = postData
            request.timeoutInterval = 10
            let accessTokenBearer = "Bearer " + SavedData().accessToken
            request.setValue(accessTokenBearer, forHTTPHeaderField: "Authorization")
            let session = URLSession.shared
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    completion(false, -1)
                }
                
                if let data = data {
                    do {
                        let successJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                        if let successDict = successJSON["success"] as? [String: Any] {
                            if let groupID = successDict["id"] as? Int{
                                completion(true, groupID)
                            }
                        } else {
                            completion(false, -1)
                        }
                    } catch {
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    // Items
    
    func createNewItem(name: String, completion: @escaping (Bool, Item?) -> Void) {
        let parameters : [String : Any] = ["name" : name]
        
        let postString = dictToString(paramaterDict: parameters)
        let postData = postString.data(using: String.Encoding.ascii, allowLossyConversion: true)!
        let urlPath: String = "https://201.kristofs.app/api/items/create"
        if let submitURL = URL(string: urlPath) {
            var request = URLRequest(url: submitURL)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = postData
            request.timeoutInterval = 10
            let accessTokenBearer = "Bearer " + SavedData().accessToken
            request.setValue(accessTokenBearer, forHTTPHeaderField: "Authorization")
            let session = URLSession.shared
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    
                }
                if let data = data {
                    do {
                        let successJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                        if let item = successJSON["success"] as? [String: Any] {
                            var name = "NA"
                            var inStock = false
                            var id = -1
                            if let itemName = item["name"] as? String {
                                name = itemName
                            }
                            if let itemInStock = item["in_stock"] as? Bool {
                                inStock = itemInStock
                            }
                            if let itemID = item["id"] as? Int {
                                id = itemID
                            }
                            let newItem = Item(inStock: inStock, name: name, suscribedUsers: [], itemID: id)
                            completion(true, newItem)
                        } else {
                            completion(false, nil)
                        }
                    } catch {
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    func suscribeToItem(itemID: Int, completion: @escaping (Bool)->Void) {
        let urlPath: String = "https://201.kristofs.app/api/items/subscribe/\(itemID)"
        if let submitURL = URL(string: urlPath) {
            var request = URLRequest(url: submitURL)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.timeoutInterval = 10
            let accessTokenBearer = "Bearer " + SavedData().accessToken
            request.setValue(accessTokenBearer, forHTTPHeaderField: "Authorization")
            let session = URLSession.shared
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    do {
                        let successJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                        if let _ = successJSON["success"] {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    } catch {
                        completion(false)
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    func unsubscribeFromItem(itemID: Int, completion: @escaping (Bool)->Void) {
        let urlPath: String = "https://201.kristofs.app/api/items/unsubscribe/\(itemID)"
        if let submitURL = URL(string: urlPath) {
            var request = URLRequest(url: submitURL)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.timeoutInterval = 10
            let accessTokenBearer = "Bearer " + SavedData().accessToken
            request.setValue(accessTokenBearer, forHTTPHeaderField: "Authorization")
            let session = URLSession.shared
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    do {
                        let successJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                        if let _ = successJSON["success"] {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    } catch {
                        completion(false)
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    func markItemInStock(itemID: Int, completion: @escaping (Bool)->Void) {
        let urlPath: String = "https://201.kristofs.app/api/items/in-stock/\(itemID)"
        if let submitURL = URL(string: urlPath) {
            var request = URLRequest(url: submitURL)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.timeoutInterval = 10
            let accessTokenBearer = "Bearer " + SavedData().accessToken
            request.setValue(accessTokenBearer, forHTTPHeaderField: "Authorization")
            let session = URLSession.shared
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    do {
                        let successJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                        if let _ = successJSON["success"] {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    } catch {
                        completion(false)
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    func markItemOutOfStock(itemID: Int, completion: @escaping (Bool)->Void) {
        let urlPath: String = "https://201.kristofs.app/api/items/out-of-stock/\(itemID)"
        if let submitURL = URL(string: urlPath) {
            var request = URLRequest(url: submitURL)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.timeoutInterval = 10
            let accessTokenBearer = "Bearer " + SavedData().accessToken
            request.setValue(accessTokenBearer, forHTTPHeaderField: "Authorization")
            let session = URLSession.shared
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    do {
                        let successJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                        if let _ = successJSON["success"] {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    } catch {
                        completion(false)
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    
    
    // Login, Logout, Registration
    
    func loginUser(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        let parameters : [String : Any] = ["email" : email,
                                           "password": password]
        let postString = dictToString(paramaterDict: parameters)
        let postData = postString.data(using: String.Encoding.ascii, allowLossyConversion: true)!
        let urlPath: String = "https://201.kristofs.app/api/login"
        if let submitURL = URL(string: urlPath) {
            var request = URLRequest(url: submitURL)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = postData
            request.timeoutInterval = 10
            let session = URLSession.shared
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!)
                    
                    completion(false, "")
                }
                if let data = data {
                    do {
                        let successJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                        if let success = successJSON["success"] {
                            if let sucessDict = success as? [String: String] {
                                let accessToken = sucessDict["token"]!
                                completion(true, accessToken)
                            }
                        } else {
                            completion(false, "")
                        }
                    } catch {
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    func logoutUser(completion: @escaping (Bool) -> Void) {
        let urlPath: String = "https://201.kristofs.app/api/logout"
        if let submitURL = URL(string: urlPath) {
            var request = URLRequest(url: submitURL)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.timeoutInterval = 10
            let accessTokenBearer = "Bearer " + SavedData().accessToken
            request.setValue(accessTokenBearer, forHTTPHeaderField: "Authorization")
            let session = URLSession.shared
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    completion(false)
                }
                if let data = data {
                    do {
                        let successJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                        if let _ = successJSON["success"] {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    } catch {
                        completion(false)
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    func registerUser(name: String, email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        let parameters : [String : Any] = ["name": name,
                                           "email" : email,
                                           "password": password,
                                           "c_password": password]
        
        
        let postString = dictToString(paramaterDict: parameters)
        let postData = postString.data(using: String.Encoding.ascii, allowLossyConversion: true)!
        let urlPath: String = "https://201.kristofs.app/api/register"
        if let submitURL = URL(string: urlPath) {
            var request = URLRequest(url: submitURL)
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = postData
            request.timeoutInterval = 10
            let session = URLSession.shared
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error)
                    completion(false, "")
                }
                if let data = data {
                    do {
                        let successJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                        if let success = successJSON["success"] {
                            if let sucessDict = success as? [String: String] {
                                let accessToken = sucessDict["token"]!
                                completion(true, accessToken)
                            }
                        } else {
                            completion(false, "")
                        }
                    } catch {
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    
    // Users
    
    func getUserDetails(completion: @escaping (Bool) -> Void) {
        let urlPath: String = "https://201.kristofs.app/api/users/details"
        if let submitURL = URL(string: urlPath) {
            var request = URLRequest(url: submitURL)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let accessTokenBearer = "Bearer " + SavedData().accessToken
            request.setValue(accessTokenBearer, forHTTPHeaderField: "Authorization")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    do {
                        print(data)
                        let dataJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                        if let userDict = dataJSON["success"] as? [String: Any] {
                            
                            print(userDict)
                            var userEmail = ""
                            var userName = ""
                            var groupID: Int? = nil
                            if let email = userDict["email"] as? String {
                                userEmail = email
                            }
                            if let name = userDict["name"] as? String {
                                userName = name
                            }
                            if let groupIdentifiter = userDict["group_id"] as? Int {
                                groupID = groupIdentifiter
                            }
                            SavedData().currentUser = User(email: userEmail, name: userName, groupID: groupID)
                            completion(true)
                            
                        } else {
                            completion(false)
                            print("couldn't parse")
                        }
                        print(dataJSON)
                        
                    } catch {
                        completion(false)
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    
    func getUserItems(completion: @escaping(Bool, [Item]) -> Void) {
        let urlPath: String = "https://201.kristofs.app/api/users/items"
        if let submitURL = URL(string: urlPath) {
            var request = URLRequest(url: submitURL)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let accessTokenBearer = "Bearer " + SavedData().accessToken
            request.setValue(accessTokenBearer, forHTTPHeaderField: "Authorization")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    do {
                        print(data)
                        let dataJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                        
                        
                        if let items = dataJSON["success"] as? [[String: Any]] {
                                var groupItems = [Item]()
                                for item in items {
                                    var name = "NA"
                                    var inStock = false
                                    var id = -1
                                    if let itemName = item["name"] as? String {
                                        name = itemName
                                    }
                                    if let itemInStock = item["in_stock"] as? Bool {
                                        inStock = itemInStock
                                    }
                                    if let itemID = item["id"] as? Int {
                                        id = itemID
                                    }
                                    let newItem = Item(inStock: inStock, name: name, suscribedUsers: [], itemID: id)
                                    groupItems.append(newItem)
                                }
                                completion(true, groupItems)
                            
                            
                        }
                        print(dataJSON)
                        
                    } catch {
                        completion(false, [])
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    // Helper method to parse grocery lists
    
    func parseAllGroceryLists(completion: @escaping (Bool)->Void) {
        getGroupItems { (success, groupItems) in
            if (success) {
                self.getUserItems(completion: { (success, userItems) in
                    if (success) {
                        var suscribedIDs = Set<Int>()
                        for userItem in userItems {
                            suscribedIDs.insert(userItem.itemID)
                        }
                        
                        var unsuscribedItems = [Item]()
                        for groupItem in groupItems {
                            if (!suscribedIDs.contains(groupItem.itemID)) {
                                unsuscribedItems.append(groupItem)
                            }
                        }
                        SavedData().suscribedItems = userItems
                        SavedData().unsuscribedItems = unsuscribedItems
                        
                        var inStockItems = [Item]()
                        var outOfStockItems = [Item]()
                        for suscribedItem in userItems {
                            if (suscribedItem.inStock) {
                                inStockItems.append(suscribedItem)
                            } else {
                                outOfStockItems.append(suscribedItem)
                            }
                        }
                        SavedData().inStockItems = inStockItems
                        SavedData().outOfStockItems = outOfStockItems
                        completion(true)
                        
                    } else {
                        completion(false)
                    }
                })
            } else {
                completion(false)
            }
        }
    }
 

    
    //MARK: Helper Function
    private func dictToString(paramaterDict: [String: Any]) -> String {
        var urlencoded = ""
        var count = 0;
        for key in paramaterDict.keys {
            count = count + 1
            urlencoded += key + "=" + String(describing: paramaterDict[key]!)
            if (count != paramaterDict.count) {
                urlencoded += "&"
            }
        }
        return urlencoded
    }
    
    
    
    
    
    
    
}
