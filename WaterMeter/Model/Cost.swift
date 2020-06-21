//
//  Cost.swift
//  WaterMeter
//
//  Created by petruta maties on 02/12/2019.
//  Copyright © 2019 petruta maties. All rights reserved.
//

import Foundation
import Firebase

class Cost {
    
    func calculateCost() {
        Firestore.firestore().document("users").collection((Auth.auth().currentUser?.uid)!).getDocuments { (user, error) in
            guard let dict = user?.documents else { return }
         }
    }
}




