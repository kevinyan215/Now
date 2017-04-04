//
//  Settings.swift
//  Now
//
//  Created by Kevin Yan on 3/4/17.
//  Copyright © 2017 Kevin Yan. All rights reserved.
//

import UIKit

import UserNotifications

class Settings: UIViewController{
    
    override func viewWillAppear(_ animated: Bool){
        print("view will appear")
    }

    override func viewDidLoad(){
        print("View did load")
        //assume granted notif authorization
        //if granted notif
        
        //set notif content
        //trigger
        //notif setttings.. time range for notifications.. randomness of notification..
        //request
        //notif add
        setNotifAlert();
    }
    
    
    func setNotifAlert(){
        let content = UNMutableNotificationContent()
        content.title = "What's up?"
        content.subtitle = ""
        content.body = "Take a picture or video!"
        content.badge = 7
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:5.0, repeats:false)
        
        let request = UNNotificationRequest(
            identifier: "identifier",
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil);
    }
}

