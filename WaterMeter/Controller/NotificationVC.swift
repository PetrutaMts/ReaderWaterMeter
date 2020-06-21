//
//  NotificationVC.swift
//  WaterMeter
//
//  Created by petruta maties on 08/01/2020.
//  Copyright © 2020 petruta maties. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationVC: UIViewController {
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "title"
        content.subtitle = "subtitle"
        content.body = "body"
        content.sound = UNNotificationSound.default
        content.threadIdentifier = "local-notifications temp"
        
        let date = Date(timeIntervalSinceNow: 10)
        let dateComponents = Calendar.current.dateComponents([.year, .month, .hour, .minute, .second], from: date)
//            Calendar([.year, .month, .hour, .minute, .second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "content", content: content, trigger: trigger)
        
        center.add(request) { (error) in
            if error != nil {
                print(error)
            }
        }
        

    }
    
}
