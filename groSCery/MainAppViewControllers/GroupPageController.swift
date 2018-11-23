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
    var subscribedItems = [Item]()
    var notSubscribedItems = [Item]()
    let networkManager = NetworkManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.getGroupSubscribers { (success) in
            print(success)
        }
        subscribedItems = SavedData().suscribedItems
        notSubscribedItems = SavedData().unsuscribedItems
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribedItems = SavedData().suscribedItems
        notSubscribedItems = SavedData().unsuscribedItems
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Not Subscribed"
        } else {
            return "Subscribed"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return notSubscribedItems.count
        } else {
            return subscribedItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupItemsCellID", for: indexPath)
        var item = Item(inStock: true, name: "", suscribedUsers: [], itemID: -1)
        if (indexPath.section == 0) {
            item = notSubscribedItems[indexPath.row]
        } else {
            item = subscribedItems[indexPath.row]
        }
        cell.textLabel?.text = item.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            let item = notSubscribedItems[indexPath.row]
            let alert = UIAlertController(title: item.name, message: "Subscribe to \(item.name)", preferredStyle: UIAlertController.Style.alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                print("ACTION 3 selected!")
                self.suscribeToItem(item: item, index: indexPath.row)
                
            })
            alert.addAction(yesAction)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let item = subscribedItems[indexPath.row]
            let alert = UIAlertController(title: item.name, message: "Unsubscribe to \(item.name)", preferredStyle: UIAlertController.Style.alert)
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
                    self.subscribedItems.append(item)
                    SavedData().suscribedItems.append(item)
                    self.notSubscribedItems.remove(at: index)
                    SavedData().unsuscribedItems.remove(at: index)
                    self.tableView.performBatchUpdates({
                        self.tableView.insertRows(at: [IndexPath(row: self.subscribedItems.count - 1, section: 1)], with: .automatic)
                        self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                    }, completion: nil)
                    if (item.inStock) {
                        SavedData().inStockItems.append(item)
                    } else {
                        SavedData().outOfStockItems.append(item)
                    }
                } else {
                    let alert = UIAlertController(title: "Subscribe Error", message: "Unable to subscribe to item.", preferredStyle: UIAlertController.Style.alert)
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
                    self.subscribedItems.remove(at: index)
                    SavedData().suscribedItems.remove(at: index)
                    self.notSubscribedItems.append(item)
                    SavedData().unsuscribedItems.append(item)
                    self.tableView.performBatchUpdates({
                        self.tableView.insertRows(at: [IndexPath(row: self.notSubscribedItems.count - 1, section: 0)], with: .automatic)
                        self.tableView.deleteRows(at: [IndexPath(row: index, section: 1)], with: .automatic)
                    }, completion: nil)
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
//                    self.tableView.reloadData()
                    
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
                                self.subscribedItems.append(item)
                                SavedData().suscribedItems.append(item)
                                self.tableView.insertRows(at: [IndexPath(row: self.subscribedItems.count - 1, section: 1)], with: .automatic)
                                SavedData().inStockItems.append(item)
//                                self.tableView.reloadData()
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

