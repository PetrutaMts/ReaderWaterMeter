//
//  LoginVC.swift
//  WaterMeter
//
//  Created by petruta maties on 08/11/2019.
//  Copyright © 2019 petruta maties. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginVC: UIViewController, GIDSignInUIDelegate {

    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                print("No user logged in!")
            } else {
                self.dismiss(animated: true, completion: nil)
                print("Welcome user: \(user?.displayName ?? "")")
//                let name = user?.displayName! as! String
                self.validateIfAccExist(completion: { (gender) in
                    if gender == true {
                        Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).setData(["gender": "","address": "", "coldWaterPrice": "", "phone": ""], merge: true)
                        Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).collection("indexes").document("data").setData(["lastIndex": "", "data": [], "costs": []], merge: true)
                    }
                })
                
//                Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).setData(["name": "name", "gender": "","address": "", "coldWaterPrice": "", "phone": ""], merge: true)
//                Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).collection("indexes").document("data").setData(["lastIndex": "", "data": [], "costs": []], merge: true)
            }
        }
    }
    
    func validateIfAccExist(completion: @escaping (Bool)->Void) {
        Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).getDocument { (data, error) in
            let dict = data?.data()
            let gender = dict!["gender"] as! String
            if gender.isEmpty {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    @IBAction func loginBtnTapped(_ sender: Any) {
        guard let email = emailTxt.text,
            let password = passwordTxt.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let error = error {
                debugPrint("Error signing in: \(error)")
                let controller = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                controller.addAction(action)
                self.present(controller, animated: true, completion: nil)
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func createAccntBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    @IBAction func loginGoogleTapped(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
        
//        self.dismiss(animated: true, completion: nil)
        
    }
    
    func firebaseLogin(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        }
    }
}
