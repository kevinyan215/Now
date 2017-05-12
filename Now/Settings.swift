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
    
    @IBOutlet weak var startTime: UITextField!
    @IBOutlet weak var endTime: UITextField!
    
    var datePicker: UIDatePicker = UIDatePicker()
    var datePickerStartTime: Date? = nil;
    var datePickerEndTime: Date? = nil;
    
    override func viewDidLoad(){
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Settings.exitFirstResponder));
        view.addGestureRecognizer(gestureRecognizer);
        
        //TODO: Proper place to put this? Better place to init UI
        datePicker.datePickerMode = UIDatePickerMode.time
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func exitFirstResponder(){
        view.endEditing(true)
    }
    
    func datePickerValueChanged() {
        print("date picker value changed")
        
        if startTime.isFirstResponder{
            startTime.text = formatDateHHMM(date: datePicker.date)
        }
        else if endTime.isFirstResponder{
            endTime.text = formatDateHHMM(date: datePicker.date)
        }
    }
    
    @IBAction func startTimeBeginEdit(_ sender: UITextField) {
        initBeginEdit(textField: sender)
    }
    
    @IBAction func endTimeBeginEdit(_ sender: UITextField, forEvent event: UIEvent) {
        initBeginEdit(textField: sender)
    }
    
    func initBeginEdit(textField: UITextField){
        textField.inputView = datePicker;
        textField.text = formatDateHHMM(date: datePicker.date)
    }
    
    @IBAction func startTimeAfterEdit(_ sender: UITextField, forEvent event: UIEvent) {
        datePickerStartTime = datePicker.date
        sender.text = formatDateHHMM(date: datePickerStartTime!)
    }
    
    @IBAction func endTimeAfterEdit(_ sender: UITextField, forEvent event: UIEvent) {
        datePickerEndTime = datePicker.date
        sender.text = formatDateHHMM(date: datePickerEndTime!)
    }
    
//    func initEndEdit(textField: UITextField){
//        textField.text = formatDateHHMM(date: datePickerEndTime!)
//    }
    
    func formatDateHHMM(date: Date) -> String{
        let timeFormatter = DateFormatter();
        timeFormatter.timeStyle = DateFormatter.Style.short;
        let formattedDate = timeFormatter.string(from: date);
        
        return formattedDate;
    }

    @IBAction func toggleNotifications(_ sender: UISwitch) {
//        print(sender.isOn);
//        print("datepicker start time", datePickerStartTime)
//        print("datepicker end time", datePickerEndTime)
        
        if datePickerStartTime != nil, let datePickerEndTime = datePickerEndTime{
            let diffTimeIntervalStartEnd = datePickerEndTime.timeIntervalSince(datePickerStartTime!)
            let randTimeIntervalStartEnd = arc4random_uniform(UInt32(diffTimeIntervalStartEnd))
            
            //TODO: Fix notifTime. Breaks when start time is before current time
            let currentDateTime: Date = Date()
            let notifTimeInterval = datePickerStartTime!.timeIntervalSince(currentDateTime) + TimeInterval(randTimeIntervalStartEnd);
            setNotifAlert(notifTimeInterval: notifTimeInterval)
            
            print("time interval different from start to end", diffTimeIntervalStartEnd)
            print("time interval from now till notification", notifTimeInterval)
            let notifDateTime = Date(timeIntervalSinceNow: notifTimeInterval)
            print("notification time", formatDateHHMM(date: notifDateTime))
        }
    }
    
    func setNotifAlert(notifTimeInterval: TimeInterval){
        let content = UNMutableNotificationContent()
        content.title = "What's up?"
        content.subtitle = ""
        content.body = "Take a picture or video!"
        content.badge = 7
        content.sound = UNNotificationSound.default()
        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:3.0, repeats:false)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:notifTimeInterval, repeats:false)
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

