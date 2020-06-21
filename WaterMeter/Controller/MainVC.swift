//
//  MainVC.swift
//  WaterMeter
//
//  Created by petruta maties on 07/11/2019.
//  Copyright © 2019 petruta maties. All rights reserved.
//

import UIKit
import Firebase
import FirebaseMLVision
import UserNotifications


class MainVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var indexTxt: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var uploadImage: UIImageView!
    @IBOutlet weak var uploadPhotoBtn: UIButton!
    @IBOutlet weak var orLabel: UILabel!
    @IBOutlet weak var nextPeriod: UILabel!
    let arrayMonth = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    //    @IBOutlet weak var indexFromImageLbl: UILabel!
    private var handle: AuthStateDidChangeListenerHandle?
    let main = Main()
    //    let text : VisionTextRecognize!
    var vision = Vision.vision()
    let calendar = Calendar.current
    
    
    //    text = vision.onDeviveTextRecognizer()
    
    //    let textRecognizer = vision.onDeviceTextRecognizer()
    //    let options = VisionCloudTextRecognizerOptions()
    //    options.languageHints = ["en"]
    //    let textRecognizer = vision.cloudTextRecognizer(options: options)
    //    let image = VisionImage(image: uiImage)
    var imagePicker: UIImagePickerController = UIImagePickerController()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        imagePicker.delegate = self
        
        isUserLogin()
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user == nil {
                print("No user logged in!")
            } else {
                self.validateMonthOfLastIndex() { index in
                    if index == true {
                        
                    }
                }
                
                let center = UNUserNotificationCenter.current()
                let content = UNMutableNotificationContent()
                content.title = "The interval for sending the index has started"
                content.sound = UNNotificationSound.default
                content.userInfo = ["value":"Data with local notif"]
                
                var dateComponents = DateComponents()
                dateComponents.calendar = Calendar.current
                dateComponents.day = 4
                dateComponents.hour = 21
                dateComponents.minute = 43
                
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                let request = UNNotificationRequest(identifier: "content", content: content, trigger: trigger)
                
                center.add(request) { (error) in
                    if error != nil {
                        print(error)
                    }
                }
            }
        }
//        validateMonthOfLastIndex() { index in
//            if index == true {
//
//            }
//        }
//        let center = UNUserNotificationCenter.current()
//        let content = UNMutableNotificationContent()
//        content.title = "The interval for sending the index has started"
//        content.sound = UNNotificationSound.default
//        content.userInfo = ["value":"Data wifth local notif"]
//
//        var dateComponents = DateComponents()
//        dateComponents.calendar = Calendar.current
//        dateComponents.day = 17
//        dateComponents.hour = 10
//        dateComponents.minute = 51
//
//
//       let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
//        let request = UNNotificationRequest(identifier: "content", content: content, trigger: trigger)
//
//        center.add(request) { (error) in
//            if error != nil {
//                print(error)
//            }
//        }
    }

//    override func viewWillAppear(_ animated: Bool) {
    func isUserLogin() {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
                self.present(loginVC, animated: true, completion: nil)
            } else {
                
                self.valiadateDate() { interval in
                    if interval {
                        self.validateMonthOfLastIndex(completion: { month in
                            if month {
                                self.sendBtn.isHidden = true
                                self.indexTxt.isHidden = true
                                self.uploadPhotoBtn.isHidden = true
                                self.orLabel.isHidden = true
                                self.nextPeriod.isHidden = false
                            } else {
                                self.indexTxt.isHidden = false
                                self.sendBtn.isHidden = false
                            }
                        })
                    } else {
                        self.indexTxt.isHidden = true
                        self.sendBtn.isHidden = true
                        self.uploadPhotoBtn.isHidden = true
                        self.orLabel.isHidden = true
                        self.nextPeriod.isHidden = false
//                        self.validateMonthOfLastIndex(completion: { month in
//                            if month == false {
//                                self.addDefauldValueFromIndex()
//                            }
//                        })
//                        self.validateMonthOfLastIndex(completion: { month in
//                            if month {
////                                self.indexTxt.isHidden = false
////                                self.sendBtn.isHidden = false
//                                self.nextPeriod.isHidden = false
//                            }
//                            else {
////                                self.indexTxt.isHidden = false
////                                self.sendBtn.isHidden = false
//                                self.nextPeriod.isHidden = false
//                                self.addDefauldValueFromIndex()
//                            }
//                        })
                    }
                }
            }
        })
    }
    
    
    
    
    @IBAction func uploadBtnPressed(_ sender: Any) {
        imagePicker.allowsEditing = true
        
        self.present(self.imagePicker, animated: true, completion: nil)
        //        }
    }
    
    //    UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    
    //    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    //        if let error = error {
    //            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
    //            ac.addAction(UIAlertAction(title: "OK", style: .default))
    //            present(ac, animated: true)
    //        } else {
    //            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
    //            ac.addAction(UIAlertAction(title: "OK", style: .default))
    //            present(ac, animated: true)
    //        }
    //    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //        imagePicker.dismiss(animated: true, completion: nil)
        //        uploadImage.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        
        info[.editedImage] as! UIImage
        uploadImage.image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        textRecognition()
        dismiss(animated: true, completion: nil)
    
    }

    func textRecognition() {
        let textRecognize = vision.onDeviceTextRecognizer()
        let indexImg = uploadImage.image
        let image = VisionImage(image: indexImg!)
        textRecognize.process(image) { (result, error) in
            guard error == nil, let result = result else { return }
            let index = result.blocks[4].text.replacingOccurrences(of: " ", with: "")
            var newIndex = ""
            
            if index.count == 8 {
                let prefix = index.dropFirst(5)
                let sufix = index.dropLast(3).dropFirst(2)
                newIndex = String(sufix +  "." + prefix)
            }
            self.indexTxt.text = "\(String(describing: newIndex))"
        }
    }
    
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        if (indexTxt.text!).isEmpty == true { //&& (indexFromImageLbl.text!) == "indexUpload" {
            let controller = UIAlertController(title: "Error", message: "Please enter the index.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            controller.addAction(action)
            self.present(controller, animated: true, completion: nil)
        } else {
            
            guard let userId = Auth.auth().currentUser?.uid else { return }
            let data = FieldValue.serverTimestamp()
            Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).collection("indexes").document("data").getDocument { [weak self] (user, error) in
                guard let dict = user?.data(),
                    let lastIndex = dict["lastIndex"] as? String else { return }
                var lindex = dict.keys.sorted()
                lindex.removeLast(3)
                var lastIndexFromArray = lindex.last
                if lindex.count == 0 {
                    lastIndexFromArray = ""
                }
                
                if lastIndex == "" {
                    print("send last index")
                    let controller = UIAlertController(title: "Error", message: "Please insert last index from the settings!", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .cancel) { _ in
                        self!.indexTxt.text = ""
                    }
                    controller.addAction(action)
                    self!.present(controller, animated: true, completion: nil)
                } else {
                    self!.main.compareIndex(lasIndex: lastIndexFromArray!, newIndex: (self?.indexTxt.text)!) { compare in
                        if compare == false {
                            let controller = UIAlertController(title: "Error", message: "incorrect index", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .cancel) { _ in
                                self!.indexTxt.text = ""
                            }
                            controller.addAction(action)
                            self!.present(controller, animated: true, completion: nil)
                        } else {
                            let indexSend = String(describing: Int(Double(self!.indexTxt.text ?? "")!.rounded(.down)))
                            
                            let controller = UIAlertController(title: "Send index", message: "The index is \(indexSend)", preferredStyle: .alert)
                            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                            controller.addAction(action)
                            self!.present(controller, animated: true, completion: nil)
                            Firestore.firestore().collection("users").document(userId).collection("indexes").document("data").setData([indexSend: data], merge: true)
                            self!.indexTxt.text = nil
                            self!.uploadImage.image = nil
                            self!.validateSendIndex()
                        }
                    }

                }
            }
        }
//        self.indexTxt.text = ""
//        self.uploadImage.image = nil
        
    }
    
    func validateSendIndex() {
        self.valiadateDate() { completion in
            if completion {
                self.indexTxt.isHidden = true
                self.sendBtn.isHidden = true
                self.uploadPhotoBtn.isHidden = true
                self.orLabel.isHidden = true
                self.nextPeriod.isHidden = false
                
            }
        }
    }
    
    func validateMonthOfLastIndex(completion: @escaping(Bool) -> Void) {
        Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).collection("indexes").document("data").getDocument { (index, error) in
            guard let dict = index?.data() else { return }
            if dict.count > 3 {
                var lastIndexDB = dict.keys.sorted()
                lastIndexDB.removeLast(3)
                let lastIndex = lastIndexDB.last
                let monthSimulator = self.calendar.component(.month, from: Date())
                let timeStamp = dict[lastIndex!] as! Timestamp
                let date = timeStamp.dateValue()
                let formatter = DateFormatter()
                formatter.dateFormat = "MM-dd-yyyy HH:mm:ss ZZZ"
                let formattedTimeZoneStr = formatter.string(from: date)
                guard let i = formattedTimeZoneStr.split(separator: "-").first, let j = Int(i) else { return }
                if j == monthSimulator {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }
    
    func valiadateDate(completion: @escaping (Bool) -> Void ) {
        let daySimulator = self.calendar.component(.day, from: Date())
        if daySimulator >= 1 && daySimulator <= 31 {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    
    func addDefauldValueFromIndex() {
        self.validateMonthOfLastIndex { month in
            if month == false {
                let monthSimulator = self.calendar.component(.month, from: Date())
                print(monthSimulator)
                let data = self.arrayMonth[monthSimulator - 1]
                Firestore.firestore().collection("users").document((Auth.auth().currentUser?.uid)!).collection("indexes").document("data").updateData(["costs" : FieldValue.arrayUnion([40]), "data": FieldValue.arrayUnion([data])])
            }
        }
      
    }
}

