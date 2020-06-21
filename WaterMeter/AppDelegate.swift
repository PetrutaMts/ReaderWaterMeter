//
//  AppDelegate.swift
//  WaterMeter
//
//  Created by petruta maties on 06/11/2019.
//  Copyright © 2019 petruta maties. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance()?.clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.sound, .badge, .alert]
        
        center.requestAuthorization(options: options) { (granted, error) in
            if error != nil {
                print(error)
            }
        }
        center.delegate = self
        
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            debugPrint("Could not login with Google. : \(error)")
        } else {
            guard let controller = GIDSignIn.sharedInstance()?.uiDelegate as? LoginVC else {return }
            guard let authentification = user.authentication else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: authentification.idToken, accessToken: authentification.accessToken)
            controller.firebaseLogin(credential)
        }
    }
}

