//
//  NetworkManager.swift
//  groSCery
//
//  Created by Naman Kedia on 11/11/18.
//  Copyright © 2018 Kristof Osswald. All rights reserved.
//

import Foundation

class NetworkManager {
    
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
    
    func createNewGroup(name: String, accessToken: String, completion: @escaping (Bool) -> Void) {
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
            let accessTokenBearer = "Bearer " + accessToken
            request.setValue(accessTokenBearer, forHTTPHeaderField: "Authorization")
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
