//
//  Main.swift
//  WaterMeter
//
//  Created by petruta maties on 19/12/2019.
//  Copyright © 2019 petruta maties. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class Main {

    func compareIndex(lasIndex: String, newIndex: String, completion: @escaping (Bool) -> Void) {
        if lasIndex > newIndex {
            completion(false)
        }
        else {
            completion(true)
        }
    } 
}


