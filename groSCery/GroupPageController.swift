//
//  GroupPageController.swift
//  groSCery
//
//  Created by Natalie Riopelle on 11/1/18.
//  Copyright © 2018 Kristof Osswald. All rights reserved.
//

import UIKit

class GroupPageController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        if segue.identifier == "mySegue"{
//            let vc = segue.destinationViewController as! GroupPageController
//        }
//    }

    @IBAction func GoToUser(_ sender: Any) {
        performSegue(withIdentifier: "GroceryListToBoughtItemSegueID", sender: Any.self)

    }
}

