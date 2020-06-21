//
//  CircleImage.swift
//  WaterMeter
//
//  Created by petruta maties on 12/11/2019.
//  Copyright © 2019 petruta maties. All rights reserved.
//

import UIKit
//@IBDesignable
class CircleImage: UIImageView {
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        self.prepareForInterfaceBuilder()
        setupView()
    }

}
