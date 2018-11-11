//
//  GroupPageController.swift
//  groSCery
//
//  Created by Natalie Riopelle on 11/1/18.
//  Copyright © 2018 Kristof Osswald. All rights reserved.
//

import UIKit

class GroupPageController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var user: User!
    var allItems = [Item]()
    var suscribedItems = [Item]()
    var notSuscribedItems = [Item]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager().createNewGroup(name: "TestGroup", accessToken: "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImU2M2E1YTMyOGY3NDQ3ZTAzODEwNTlhY2YzOTc2NTI2YmJmZWI2NDg0YzY4MWY1MjM2YzcwYjgzZTYzMjJjZTI4NTk2MzljMDg1NGI0NTY1In0.eyJhdWQiOiIxIiwianRpIjoiZTYzYTVhMzI4Zjc0NDdlMDM4MTA1OWFjZjM5NzY1MjZiYmZlYjY0ODRjNjgxZjUyMzZjNzBiODNlNjMyMmNlMjg1OTYzOWMwODU0YjQ1NjUiLCJpYXQiOjE1NDE5Njk4MzYsIm5iZiI6MTU0MTk2OTgzNiwiZXhwIjoxNTczNTA1ODM2LCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.Die479v2ivgzIDaybBfdYmOEUIcDODfMQuuxcbk990kjhTk1oIqIm-MQ3H3Q_AwUDjwiLERlTqra3M5d4FmI6lid5T4PjLk9PdIm9kso520OdWYd791yzjgcwTvZhSiqvrWfmGUFy7dSzyssHzl3LSnL9QQ-NIMB2ga4ELYziUYkEcZgdcuMb3L3jIhormwfxtTg1Qi1n3NtXLIY5liMRAal6sr0ZMHMbLbL7D-oJgFIFT9Si3vLMHZwzuRXbeEZAgYI3HN7YduFjhmp1j2IOCP-lZq2_M0__XrHsVOPiS2QAz0ALuyzTnh8KRTeE6J8eZW9EEmfrzTvXRQ--CrRnw9nrp8DdXmmDZjiiKTLEoq-LrNGcf71WyOfZ18ww-1Gk3msChwPQBRE9QzXBvEtR2ej6wsMKfbvo22S25pf96d1vGGN24r82SdtaQ1eWboIpzxOBm9X8Fy-7e6zmUn-inXxv_X3RIIXSUz7NUY3hF4-RsDmZAe1oDUO1urP-PZqktnjbvYS8EmqloVAW29gUHd4xYK5_fGyM0G-N9Qpw4mmk0XeeLPIziwjfhzbC4rgXs7dC4bvr6zJtBYDqVB0NOejtcXqPnFFRmfxOBrVfc4RVLvgnc6hDKJL44CJPgdxBKsJz3MAMLhLxtQYhPxKc1BIYyY43xJgyaIr1j2FfcM") { (success) in
            print(success)
        }
        suscribedItems.append(Item(inStock: true, name: "Eggs", suscribedUsers: ["1"]))
        suscribedItems.append(Item(inStock: true, name: "Banana", suscribedUsers: ["1"]))
        suscribedItems.append(Item(inStock: false, name: "Apple", suscribedUsers: ["1"]))
        suscribedItems.append(Item(inStock: true, name: "Milk", suscribedUsers: ["1"]))
        suscribedItems.append(Item(inStock: false, name: "Water", suscribedUsers: ["1"]))
        suscribedItems.append(Item(inStock: true, name: "Cereal", suscribedUsers: ["1"]))
        
        notSuscribedItems.append(Item(inStock: true, name: "Cookies", suscribedUsers: ["1"]))
        notSuscribedItems.append(Item(inStock: false, name: "Toilet Paper", suscribedUsers: ["1"]))
        notSuscribedItems.append(Item(inStock: false, name: "Orange Juice", suscribedUsers: ["1"]))

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Not Suscribed"
        } else {
            return "Suscribed"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return notSuscribedItems.count
        } else {
            return suscribedItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "GroupItemsCellID")
        var item = Item(inStock: true, name: "", suscribedUsers: [])
        if (indexPath.section == 0) {
            item = notSuscribedItems[indexPath.row]
        } else {
            item = suscribedItems[indexPath.row]
        }
        cell.textLabel?.text = item.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            let item = notSuscribedItems[indexPath.row]
            let alert = UIAlertController(title: item.name, message: "Suscribe to \(item.name)", preferredStyle: UIAlertController.Style.alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                print("ACTION 3 selected!")
                self.suscribeToItem(item: item, index: indexPath.row)
                
            })
            alert.addAction(yesAction)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let item = suscribedItems[indexPath.row]
            let alert = UIAlertController(title: item.name, message: "Unsuscribe to \(item.name)", preferredStyle: UIAlertController.Style.alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                print("ACTION 3 selected!")
                self.unsuscribeItem(item: item, index: indexPath.row)
            })
            alert.addAction(yesAction)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
    }
    
    func suscribeToItem(item: Item, index: Int) {
        suscribedItems.append(item)
        notSuscribedItems.remove(at: index)
        tableView.reloadData()
    }
    
    func unsuscribeItem(item: Item, index: Int) {
        suscribedItems.remove(at: index)
        notSuscribedItems.append(item)
        tableView.reloadData()
    }
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {
        if let addItemVC = segue.source as? AddItemViewController {
            if let itemName = addItemVC.itemNameTextField.text {
            
                NetworkManager().createNewItem(name: itemName) { (success) in
                    if (success) {
                        self.suscribedItems.append(Item(inStock: true, name: itemName, suscribedUsers: []))
                        self.tableView.reloadData()
                    } else {
                        
                    }
                }
            }
            
        }
        
    }

    
    
    
    
}

