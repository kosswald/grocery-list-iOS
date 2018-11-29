//
//  GroceryListViewController.swift
//  groSCery
//
//  Created by Naman Kedia on 10/28/18.
//  Copyright © 2018 Kristof Osswald. All rights reserved.
//

import UIKit



protocol AddRemoveItemDelegate: class {
    func didBuyItem(item: Item, index: Int, price: String)
    func didMarkItemOutOfStock(item: Item, index: Int)
}

class GroceryListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddRemoveItemDelegate {

    // MARK: Properties
    
    var user: User!
    var allItems = [Item]()
    var itemsInStock = [Item]()
    var itemsOutOfStock = [Item]()
    let networkManager = NetworkManager()
    private let refreshControl = UIRefreshControl()

    
    // MARK: IB Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        itemsInStock = SavedData().inStockItems
        itemsOutOfStock = SavedData().outOfStockItems
        user = SavedData().currentUser
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshItems(_:)), for: .valueChanged)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "\(user.name)'s List"
        itemsInStock = SavedData().inStockItems
        itemsOutOfStock = SavedData().outOfStockItems
        tableView.reloadData()
    }
    
    
    @objc private func refreshItems(_ sender: Any) {
        // Fetch Weather Data
        print("refreshed")
        networkManager.parseAllGroceryLists { (success) in
            DispatchQueue.main.async {
                if (success) {
                    self.itemsOutOfStock = SavedData().outOfStockItems
                    self.itemsInStock = SavedData().inStockItems
                    self.tableView.reloadData()
                } else {
                    let alert = UIAlertController(title: "Refresh Error", message: "Couldn't load items.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                self.refreshControl.endRefreshing()
            }
            
        }
        
    }

    
    // MARK: Table View Data Source and Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0){
            return itemsOutOfStock.count
        } else {
            return itemsInStock.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Out of Stock"
        } else {
            return "In Stock"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCellResuableID", for: indexPath)
        var item = Item(inStock: true, name: "", suscribedUsers: [], itemID: -1)
        if (indexPath.section == 0) {
            item = itemsOutOfStock[indexPath.row]
        } else {
            item = itemsInStock[indexPath.row]
        }
        cell.textLabel?.text = item.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            performSegue(withIdentifier: "GroceryListToBoughtItemSegueID", sender: indexPath.row)
        } else {
            let item = itemsInStock[indexPath.row]
            let alert = UIAlertController(title: item.name, message: "Mark item out of stock", preferredStyle: UIAlertController.Style.alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { (action) -> Void in
                print("ACTION 3 selected!")
                self.didMarkItemOutOfStock(item: item, index: indexPath.row)
            })
            alert.addAction(yesAction)

            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: Add Remove Item Delegate
    func didBuyItem(item: Item, index: Int, price: String) {
        
        networkManager.markItemInStock(itemID: item.itemID) { (success) in
            DispatchQueue.main.async {
                if (success) {
                    self.networkManager.purchaseItem(itemID: item.itemID, price: price, completion: { (success) in
                        print(success)
                    })
                    item.inStock = true
                    self.itemsInStock.append(item)
                    SavedData().inStockItems.append(item)
                    self.itemsOutOfStock.remove(at: index)
                    SavedData().outOfStockItems.remove(at: index)
                    self.tableView.performBatchUpdates({
                        self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                        self.tableView.insertRows(at: [IndexPath(row: self.itemsInStock.count - 1, section: 1)], with: .automatic)
                    }, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Unable to mark item in stock.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
       
    }
    
    func didMarkItemOutOfStock(item: Item, index: Int) {
        networkManager.markItemOutOfStock(itemID: item.itemID) { (success) in
            DispatchQueue.main.async {
                if (success) {
                    item.inStock = false
                    self.itemsOutOfStock.append(item)
                    SavedData().outOfStockItems.append(item)
                    self.itemsInStock.remove(at: index)
                    SavedData().inStockItems.remove(at: index)
                    self.tableView.performBatchUpdates({
                        self.tableView.deleteRows(at: [IndexPath(row: index, section: 1)], with: .automatic)
                        self.tableView.insertRows(at: [IndexPath(row: self.itemsOutOfStock.count-1, section: 0)], with: .automatic)
                    }, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Unable to mark item out of stock.", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
       
    }
    
    
    // MARK: Helpers
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "GroceryListToBoughtItemSegueID") {
            if let boughtItemVC = segue.destination as? BoughtItemViewController {
                if let index = sender as? Int {
                    boughtItemVC.item = itemsOutOfStock[index]
                    boughtItemVC.index = index
                    boughtItemVC.delegate = self
                }
            }
        }
    }
    
    
    @IBAction func GoToUser(_ sender: Any) {
        performSegue(withIdentifier: "UserToGroupSegue", sender: Any.self)
        
    }
    
}
