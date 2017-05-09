//
//  Settings.swift
//  Now
//
//  Created by Kevin Yan on 3/4/17.
//  Copyright © 2017 Kevin Yan. All rights reserved.
//

import UIKit
import UserNotifications

class Settings: UIViewController, UNUserNotificationCenterDelegate{
    
    @IBOutlet weak var datePicker: UIDatePicker!
    var datePickerStartTime: Date? = nil;
    var datePickerEndTime: Date? = nil;
    var lastDateTimeSet: Date? = nil;
    var lastDateTextFieldClicked: UITextField? = nil;
    var notifTimeInterval: TimeInterval?;
    
    override func viewDidLoad(){
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Settings.exitFirstResponder));
        view.addGestureRecognizer(gestureRecognizer);
    }
    
    func exitFirstResponder(){
        view.endEditing(true)
        datePicker.isHidden = true;
    }
    
    @IBAction func startTimeBeginEdit(_ sender: UITextField) {
//        print("start time button pressed")
        datePicker.isHidden = false;
        lastDateTextFieldClicked = sender;
    }
    
    @IBAction func endTimeBeginEdit(_ sender: UITextField, forEvent event: UIEvent) {
//        print("end time button pressed")
        datePicker.isHidden = false;
        lastDateTextFieldClicked = sender;
    }
    
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        print("date picker value changed")
        
        lastDateTimeSet = sender.date;
        lastDateTextFieldClicked?.text = formatDateHHMM(date: lastDateTimeSet!)
    }
    
    @IBAction func startTimeAfterEdit(_ sender: UITextField, forEvent event: UIEvent) {
        datePickerStartTime = lastDateTimeSet;
    }
    
    @IBAction func endTimeAfterEdit(_ sender: UITextField, forEvent event: UIEvent) {
        datePickerEndTime = lastDateTimeSet;
    }

    @IBAction func toggleNotifications(_ sender: UISwitch) {
//        print(sender.isOn);
//        print("datepicker start time", datePickerStartTime)
//        print("datepicker end time", datePickerEndTime)
        
        let diffTimeIntervalStartEnd = datePickerEndTime?.timeIntervalSince(datePickerStartTime!)
        let randTimeIntervalStartEnd = arc4random_uniform(UInt32(diffTimeIntervalStartEnd!))
        
        print("time interval different from start to end", diffTimeIntervalStartEnd)
        
        //TODO: Fix notifTime. Breaks when start time is before current time
        let currentDateTime: Date = Date()
        notifTimeInterval = datePickerStartTime!.timeIntervalSince(currentDateTime) + TimeInterval(randTimeIntervalStartEnd);
        
        print("time interval from now till notification", notifTimeInterval!)
        
        let notifDateTime = Date(timeIntervalSinceNow: notifTimeInterval!)
        print("notification time", formatDateHHMM(date: notifDateTime))
        
        setNotifAlert()
    }
    
    func formatDateHHMM(date: Date) -> String{
        let timeFormatter = DateFormatter();
        timeFormatter.timeStyle = DateFormatter.Style.short;
        let formattedDate = timeFormatter.string(from: date);
        
        return formattedDate;
    }
    
    func setNotifAlert(){
        let content = UNMutableNotificationContent()
        content.title = "What's up?"
        content.subtitle = ""
        content.body = "Take a picture or video!"
        content.badge = 7
        content.sound = UNNotificationSound.default()
        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:3.0, repeats:false)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:notifTimeInterval!, repeats:false)
        let request = UNNotificationRequest(
            identifier: "identifier",
            content: content,
            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {
        error in
            print("do this action after adding the notification");
        });
    }

}

