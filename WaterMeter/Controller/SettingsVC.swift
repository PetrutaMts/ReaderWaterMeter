//
//  Settings.swift
//  WaterMeter
//
//  Created by petruta maties on 18/11/2019.
//  Copyright © 2019 petruta maties. All rights reserved.
//

import UIKit
import Firebase
enum SettingsType {
    case user
    case administration
}

class SettingsVC: UIViewController {
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var administrationView: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        if segmentControl.selectedSegmentIndex == 0 {
            userView.alpha = 1
            administrationView.alpha = 0
        } else {
            userView.alpha = 0
            administrationView.alpha = 1
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
