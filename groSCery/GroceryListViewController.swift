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
    
    // MARK: IB Outlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        itemsInStock = SavedData().inStockItems
        itemsOutOfStock = SavedData().outOfStockItems
        user = SavedData().currentUser

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "\(user.name)'s List"
        itemsInStock = SavedData().inStockItems
        itemsOutOfStock = SavedData().outOfStockItems
        tableView.reloadData()
        
        
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TableViewCellResuableID")
        var item = Item(inStock: true, name: "", suscribedUsers: [], itemID: -1)
        if (indexPath.section == 0) {
            item = itemsOutOfStock[indexPath.row]
        } else {
            item = itemsInStock[indexPath.row]
        }
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "In stock: \(item.inStock)"
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
        itemsInStock.append(item)
        itemsOutOfStock.remove(at: index)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didMarkItemOutOfStock(item: Item, index: Int) {
        itemsOutOfStock.append(item)
        itemsInStock.remove(at: index)
        DispatchQueue.main.async {
            self.tableView.reloadData()
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
