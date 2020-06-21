//
//  MenuVC.swift
//  WaterMeter
//
//  Created by petruta maties on 07/11/2019.
//  Copyright © 2019 petruta maties. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class MenuVC: UIViewController {

    // Outlets
    
    @IBOutlet weak var avatarImg: CircleImage!
    @IBOutlet weak var loginBtn: UIButton!
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue){}
     var bgColor : UIColor?
    private var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.revealViewController()?.rearViewRevealWidth = self.view.frame.size.width - 60
        //NotificationCenter.default.addObserver(self, selector: #selector(userDataChange(_:)), name: Notification.Name("notifUserDate"), object: nil)
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
                self.present(loginVC, animated: true, completion: nil)
            }
        })
    }
    
    func setupView() {
        Auth.auth().addStateDidChangeListener() { auth, user in
            print(Auth.auth().currentUser?.displayName)
            
            if user != nil {
                Firestore.firestore().collection("users").document((user?.uid)!).getDocument(completion: { (user, error) in
                    guard let dict = user?.data(),
                        let name = dict["name"] as? String,
                        let red = dict["red"] as? Double,
                        let green = dict["green"] as? Double,
                        let blue = dict["blue"] as? Double
                    else { return }
                    self.avatarImg.backgroundColor = self.getColorBackFromFirebase(red: red, green: green, blue: blue)
                    self.loginBtn.setTitle(name, for: .normal)
                })
                self.loginBtn.setTitle(Auth.auth().currentUser?.displayName, for: .normal)
            } else {
                self.loginBtn.setTitle("Login", for: .normal)
                self.avatarImg.backgroundColor = self.bgColor
            }
        }
    }
    
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "toMenu", sender: nil)
        }
    }
    
    func getColorBackFromFirebase(red: Double, green: Double, blue: Double) -> UIColor {
        let red = CGFloat(red)
        let green = CGFloat(green)
        let blue = CGFloat(blue)
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
    
    @IBAction func settingsBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "toSettings", sender: nil)
    }

}
