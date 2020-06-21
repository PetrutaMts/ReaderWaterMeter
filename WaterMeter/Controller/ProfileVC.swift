//
//  ProfileVC.swift
//  WaterMeter
//
//  Created by petruta maties on 13/11/2019.
//  Copyright © 2019 petruta maties. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ProfileVC: UIViewController {
    
    

    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var nameTxt: UILabel!
    @IBOutlet weak var emailTxt: UILabel!
    @IBOutlet weak var addressTxt: UILabel!
    
    @IBOutlet weak var bgView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        
        
        let authFirebase = Auth.auth()
        do {
            print("logout!")
            try authFirebase.signOut()
                dismiss(animated: true, completion: nil)
        } catch let signOutError as NSError {
            debugPrint("Error signing out \(signOutError)")
            let controller = UIAlertController(title: "Error signing out", message: "\(signOutError)", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            controller.addAction(action)
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func setupView() {
        nameTxt.text = Auth.auth().currentUser?.displayName
        emailTxt.text = Auth.auth().currentUser?.email
        Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).getDocument { [weak self] (user, error) in
            guard let dict = user?.data(),
            let addr = dict["address"] as? String,
            let name = dict["name"] as? String,
            let red = dict["red"] as? Double,
            let green = dict["green"] as? Double,
            let blue = dict["blue"] as? Double
            else { return }
            self?.profileImg.backgroundColor = self?.getColorBackFromFirebase(red: red, green: green, blue: blue)
            self?.addressTxt.text = addr
            self?.nameTxt.text = name
            
        }
    }
    
    func getColorBackFromFirebase(red: Double, green: Double, blue: Double) -> UIColor {
        let red = CGFloat(red)
        let green = CGFloat(green)
        let blue = CGFloat(blue)
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
