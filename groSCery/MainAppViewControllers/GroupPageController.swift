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
    let networkManager = NetworkManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        suscribedItems = SavedData().suscribedItems
        notSuscribedItems = SavedData().unsuscribedItems
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        suscribedItems = SavedData().suscribedItems
        notSuscribedItems = SavedData().unsuscribedItems
        tableView.reloadData()
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
        var item = Item(inStock: true, name: "", suscribedUsers: [], itemID: -1)
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
        networkManager.suscribeToItem(itemID: item.itemID) { (success) in
            DispatchQueue.main.async {
                
                if (success) {
                    self.suscribedItems.append(item)
                    SavedData().suscribedItems.append(item)
                    self.notSuscribedItems.remove(at: index)
                    SavedData().unsuscribedItems.remove(at: index)
                    if (item.inStock) {
                        SavedData().inStockItems.append(item)
                    } else {
                        SavedData().outOfStockItems.append(item)
                    }
                    self.tableView.reloadData()
                    
                } else {
                    let alert = UIAlertController(title: "Suscribe Error", message: "Unable to subscribe to item.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }
        
    }
    
    func unsuscribeItem(item: Item, index: Int) {
        networkManager.unsubscribeFromItem(itemID: item.itemID) { (success) in
            DispatchQueue.main.async {
                if (success) {
                    self.suscribedItems.remove(at: index)
                    SavedData().suscribedItems.remove(at: index)
                    self.notSuscribedItems.append(item)
                    SavedData().unsuscribedItems.append(item)
                    if (item.inStock) {
                        var i = 0
                        for inStockItem in SavedData().inStockItems {
                            if (inStockItem.itemID == item.itemID) {
                                SavedData().inStockItems.remove(at: i)
                                break
                            }
                            i = i + 1
                        }
                    } else {
                        var i = 0
                        for outOfStockItem in SavedData().outOfStockItems {
                            if (outOfStockItem.itemID == item.itemID) {
                                SavedData().outOfStockItems.remove(at: i)
                                break
                            }
                            i = i + 1
                        }
                    }
                    self.tableView.reloadData()
                    
                } else {
                    let alert = UIAlertController(title: "Unsuscribe Error", message: "Unable to unsuscribe to item.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func unwindToVC1(segue:UIStoryboardSegue) {
        if let addItemVC = segue.source as? AddItemViewController {
            if let itemName = addItemVC.itemNameTextField.text {
                
                NetworkManager().createNewItem(name: itemName) { (success, item) in
                    DispatchQueue.main.async {
                        if (success) {
                            if let item = item {
                                self.suscribedItems.append(item)
                                SavedData().suscribedItems.append(item)
                                SavedData().inStockItems.append(item)
                                self.tableView.reloadData()
                            }
                          
                        } else {
                            let alert = UIAlertController(title: "Add Item Error", message: "Unable to add item.", preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                   
                }
            }
        }
        
    }
    
    
    
    
    
}

