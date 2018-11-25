//
//  GuestListViewController.swift
//  groSCery
//
//  Created by Naman Kedia on 11/25/18.
//  Copyright © 2018 Kristof Osswald. All rights reserved.
//

import UIKit

class GuestListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var itemsInStock = [Item]()
    var itemsOutOfStock = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        itemsInStock = [Item(inStock: true, name: "Apple", suscribedUsers: [], itemID: 0), Item(inStock: true, name: "Banana", suscribedUsers: [], itemID: 0), Item(inStock: true, name: "Orange Juice", suscribedUsers: [], itemID: 0), Item(inStock: true, name: "Milk", suscribedUsers: [], itemID: 0)]
        itemsOutOfStock =  [Item(inStock: false, name: "Toilet Paper", suscribedUsers: [], itemID: 0), Item(inStock: false, name: "Coco Pops", suscribedUsers: [], itemID: 0), Item(inStock: false, name: "Garlic", suscribedUsers: [], itemID: 0)]
    }
    
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "GuestTableViewCellResuableID", for: indexPath)
        var item = Item(inStock: true, name: "", suscribedUsers: [], itemID: -1)
        if (indexPath.section == 0) {
            item = itemsOutOfStock[indexPath.row]
        } else {
            item = itemsInStock[indexPath.row]
        }
        cell.textLabel?.text = item.name
        return cell
    }
    


}
