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
    
    @IBAction func toggleNotifications(_ sender: UISwitch) {
        print(sender.isOn);
        print("UIDatePicker: ", timeSet.date);
//        setTime();
        
        //formatting to just get time from UIDatePicker
        var timeFormatter = DateFormatter();
        timeFormatter.timeStyle = DateFormatter.Style.short
        var formattedDate = timeFormatter.string(from: timeSet.date)
        
        print("formmated date: ", formattedDate)
        
    }
    
    @IBOutlet weak var timeSet: UIDatePicker!
    
    
    override func viewWillAppear(_ animated: Bool){
        print("view will appear")
    }
    
    override func viewDidLoad(){
        print("View did load")
        //assume granted notif authorization
//        if(sender.isOn){
            setNotifAlert();
//        }
    }
    
    func setTime(){
        timeSet.addTarget(self, action: Selector("actionHandler:"), for: UIControlEvents.valueChanged)
    }
    
    func actionHandler(sender: UIDatePicker){
//        var timeFormatter = DateFormatter();
//        timeFormatter.timeStyle = DateFormatterStyle.ShortStyle
        
        
    }
    
    
    func setNotifAlert(){
        let content = UNMutableNotificationContent()
        content.title = "What's up?"
        content.subtitle = ""
        content.body = "Take a picture or video!"
        content.badge = 7
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:3.0, repeats:false)
        let request = UNNotificationRequest(
            identifier: "identifier",
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil);
    }
}

