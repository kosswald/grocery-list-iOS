//
//  InitialViewController.swift
//  groSCery
//
//  Created by Naman Kedia on 11/11/18.
//  Copyright © 2018 Kristof Osswald. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpAttributedTitle()
        self.view.backgroundColor = UIColor(red: 244/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1.0)
        
    }
    
    func setUpAttributedTitle() {
        let scFont = UIFont.systemFont(ofSize: 60, weight: UIFont.Weight.bold)
        let normalFont = UIFont.systemFont(ofSize: 60, weight: UIFont.Weight.regular)
        let titleText = NSMutableAttributedString(string: "gro", attributes: [NSAttributedString.Key.font: normalFont])
        titleText.append(NSMutableAttributedString(string: "SC", attributes: [NSAttributedString.Key.font: scFont, NSAttributedString.Key.foregroundColor: UIColor(red: 254/255.0, green: 203/255.0, blue: 47/255.0, alpha: 1.0)]))
        titleText.append(NSMutableAttributedString(string: "ery", attributes: [NSAttributedString.Key.font: normalFont]))
        titleLabel.attributedText = titleText
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
//        if (SavedData().loggedIn) {
//            if (SavedData().currentUser.groupID != nil) {
//                performSegue(withIdentifier: "AlreadyLoggedInSegueID", sender: nil)
//            }
//        }
    }
    
    @IBAction func unwindInitialVC(segue:UIStoryboardSegue) {
        SavedData().loggedIn = false
        
    }
    
 
}
