//
//  BoughtItemViewController.swift
//  groSCery
//
//  Created by Naman Kedia on 10/28/18.
//  Copyright © 2018 Kristof Osswald. All rights reserved.
//

import UIKit

class BoughtItemViewController: UIViewController {

    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var priceTextField: UITextField!
    
    var item: Item!
    var index: Int!
    var delegate: AddRemoveItemDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemLabel.text = item.name
        priceTextField.becomeFirstResponder()
    }
    
    @IBAction func didClickSubmitButton(_ sender: Any) {
        priceTextField.resignFirstResponder()
        delegate.didBuyItem(item: item, index: index, price: priceTextField.text!)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
