//
//  Profile.swift
//  WaterMeter
//
//  Created by petruta maties on 13/11/2019.
//  Copyright © 2019 petruta maties. All rights reserved.
//

import Foundation
import Firebase

class Profile {
    private(set) var name: String!
    private(set) var email: String!
    private(set) var address: String!
    private(set) var profile: UIImageView!
    
    init(name: String, email: String, address: String, profile: UIImageView) {
        self.name = name
        self.email = email
        self.address = address
        self.profile = profile
    }
    
}
