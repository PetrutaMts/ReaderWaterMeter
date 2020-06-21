//
//  CheckBox.swift
//  WaterMeter
//
//  Created by petruta maties on 18/11/2019.
//  Copyright © 2019 petruta maties. All rights reserved.
//

import UIKit

class CheckBox: UIButton {

    //images
    let checkedImg = UIImage(named: "checkimg") as! UIImage
    let unCheckedImg = UIImage(named: "uncheck") as! UIImage
    
    //bool
    var isChecked: Bool = false {
        didSet{
            if isChecked == true {
                self.setImage(checkedImg, for: .normal)
            } else {
                self.setImage(unCheckedImg, for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        self.addTarget(self, action: "buttonClicked:", for: UIControl.Event.touchUpInside)
        self.isChecked = false
    }
    
    func buttonClicked(sender: UIButton) {
        if(sender == self) {
            if isChecked == true {
                isChecked = false
            } else {
                isChecked = true
            }
        }
    }

}
