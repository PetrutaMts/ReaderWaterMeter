//
//  History.swift
//  WaterMeter
//
//  Created by petruta maties on 05/12/2019.
//  Copyright © 2019 petruta maties. All rights reserved.
//

import Foundation
import Firebase


class History {
    var price : Double = 7.0
    
    func extractCost(completion: @escaping ([Double], [String]) -> Void)  {
        
        
        Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).collection("indexes").document("data").getDocument { (indexes, error) in
            var dict = indexes?.data()
            let val = dict!["costs"] as! [Double]
            guard let data = dict?["data"] else { return }
            completion(val, data as! [String])
        }
    }
    

    func extractPriceFromDB(completion: @escaping (Double) -> Void) {
        Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).getDocument { (data, error) in
            completion(self.price)
        }
    }
    
}

