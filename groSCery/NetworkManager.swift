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
    
    func getGroupItems(completion: @escaping(Bool) -> Void) {
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
                        
                        if let dictonary = dataJSON["success"] as? [[String: Any]] {
                            print(dictonary)
                            
                        }
                        print(dataJSON)
                        
                    } catch {
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    func createNewGroup(name: String, completion: @escaping (Bool, String) -> Void) {
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
                    completion(false, "")
                }
                if let data = data {
                    do {
                        let successJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                        if let successDict = successJSON["success"] as? [String: String] {
                            if let groupID = successDict["id"] {
                                completion(true, groupID)
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
    
    func suscribeToGroup(name: String) {
        
    }
    
    // Items
    
    func createNewItem(name: String, completion: @escaping (Bool) -> Void) {
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
            let session = URLSession.shared
            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if error != nil {
                    
                }
                if let data = data {
                    do {
                        let successJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                        if let success = successJSON["success"] {
                            completion(true)
                        } else {
                            completion(false)
                        }
                    } catch {
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
    
    func getUserDetails(accessToken: String) {
        let urlPath: String = "https://201.kristofs.app/api/users/details"
        if let submitURL = URL(string: urlPath) {
            var request = URLRequest(url: submitURL)
            request.httpMethod = "GET"
            let session = URLSession.shared
            let accessTokenBearer = "Bearer " + accessToken
            request.setValue(accessTokenBearer, forHTTPHeaderField: "Authorization")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

            session.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data {
                    do {
                        print(data)
                        let dataJSON = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                        if let dictonary = dataJSON["success"] as? [String: Any] {
                            print(dictonary)
                            
                        }
                        print(dataJSON)
                        
                    } catch {
                        print(error)
                    }
                }
            }).resume()
        }
    }
    
    
    func getUserItems(completion: @escaping(Bool) -> Void) {
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
                        
                        if let dictonary = dataJSON["success"] as? [[String: Any]] {
                            print(dictonary)
                            
                        }
                        print(dataJSON)
                        
                    } catch {
                        print(error)
                    }
                }
            }).resume()
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
