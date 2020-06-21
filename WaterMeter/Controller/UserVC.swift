//
//  UserVC.swift
//  WaterMeter
//
//  Created by petruta maties on 29/11/2019.
//  Copyright © 2019 petruta maties. All rights reserved.
//

import UIKit
import Firebase

class UserVC: UIViewController {
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var lastIndexTxt: UITextField!
    @IBOutlet weak var addressTxt: UITextField!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var lastIndexLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        maleBtn.isSelected = true
        nameTxt.text = Auth.auth().currentUser?.displayName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).collection("indexes").document("data").getDocument { [weak self] (user, error) in
            guard let dict = user?.data(),
                let lastIndex = dict["lastIndex"] as? String else { return }
            if lastIndex != "" {
                self?.lastIndexTxt.isHidden = true
                self?.lastIndexLbl.isHidden = true
            }
        }
    }
    
    @IBAction func maleBtnPressed(_ sender: Any) {
        if maleBtn.isSelected {
            maleBtn.isSelected = false
            femaleBtn.isSelected = true
        } else {
            maleBtn.isSelected = true
            femaleBtn.isSelected = false
        }
    }
    
    @IBAction func femaleBtnPressed(_ sender: Any) {
        if femaleBtn.isSelected {
            femaleBtn.isSelected = false
            maleBtn.isSelected = true
        } else {
            femaleBtn.isSelected = true
            maleBtn.isSelected = false
        }
    }
    
    @IBAction func saveBtnPressed(_ sender: Any) {
        let gender: String
        if maleBtn.isSelected {
            gender = "male"
            
        } else {
            gender = "female"
        }
        
        guard let userId = Auth.auth().currentUser?.uid else { return }
        guard let index = lastIndexTxt.text else { return }
        guard let name = nameTxt.text else  { return }
        guard let address = addressTxt.text else { return }
        if lastIndexTxt.isHidden {
            if name.isEmpty || address.isEmpty {
               alertRequiredToFillIn()
            } else {
                
                Firestore.firestore().collection("users").document(userId).setData(["name": nameTxt.text,"gender": gender, "address": addressTxt.text ], merge: true)
            }
        }
        else {
            if name.isEmpty || address.isEmpty || index.isEmpty {
               alertRequiredToFillIn()
            } else {
                Firestore.firestore().collection("users").document(userId).setData(["name": nameTxt.text,"gender": gender, "address": addressTxt.text ], merge: true)
                Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).collection("indexes").document("data").setData(["lastIndex": index], merge: true)
            }
        }
        
        let myAlert = UIAlertController(title: "Alert", message: "The changes were saved.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true) {
            self.addressTxt.text = ""
            self.lastIndexTxt.text = ""
        }
    }
    
    func alertRequiredToFillIn() {
        let myAlert = UIAlertController(title: "Alert", message: "All fields are required to fill in", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        myAlert.addAction(okAction)
        self.present(myAlert, animated: true, completion: nil)
    }
    
}
