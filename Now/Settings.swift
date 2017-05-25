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
        print("datepicker start time", datePickerStartTime)
        print("datepicker end time", datePickerEndTime)
        
        if datePickerStartTime != nil, datePickerEndTime != nil{
            setNotifAlert(notifTimeInterval: getNotifTimeInterval())
        }
    }
    
    func getNotifTimeInterval() -> TimeInterval{
        let diffTimeIntervalBetweenStartEnd = abs(datePickerEndTime!.timeIntervalSince(datePickerStartTime!))
        print("time interval different from start to end", diffTimeIntervalBetweenStartEnd)

        let randTimeIntervalBetweenStartEnd = arc4random_uniform(UInt32(diffTimeIntervalBetweenStartEnd))
   
        //TODO: Fix notifTime. Breaks when start time is before current time
        var notifTimeInterval: TimeInterval
        let currentDateTime: Date = Date()
        
        let diffTimeIntervalNowAndStart = datePickerStartTime!.timeIntervalSince(currentDateTime)
        
//        datePickerStartTime, datePickerEndTime, currentDateTime
        
//        datePickerEndTime - datePickerStartTime >= 0
//        datePickerEndTime - datePickerStartTime < 0 
        
//        currentDateTime = 9p.m.
        
//        startTime = 7 p.m., endTime = 1 a.m. //rand(endTime - startTime) //conditions:  startTime < currentDateTime && endTime > currentDateTime
//        startTime = 11 p.m., endTime = 1 a.m. //check //conditions startTime > currentDateTime && endTime > currentDateTime
//        startTime = 7 p.m., endTime 8 p.m. //check? //conditions: startTime < currentDateTime && endTime < currentDateTime
        
        
        //times relative to current time
        //before, after
        //after, after = //after, before
        
        //before, before
        
 
        if datePickerStartTime! < currentDateTime{
            print("datePickerStartTime! > currentDateTime")
            let TWENTY_FOUR_HOURS: TimeInterval = 3600.0 * 24
            let diffTimeIntervalNowAndStartOtherWay = TWENTY_FOUR_HOURS + diffTimeIntervalNowAndStart
            notifTimeInterval = diffTimeIntervalNowAndStartOtherWay + TimeInterval(randTimeIntervalBetweenStartEnd)
        }
        else{
            print("else")
            notifTimeInterval = datePickerStartTime!.timeIntervalSince(currentDateTime) + TimeInterval(randTimeIntervalBetweenStartEnd)
        }

        
        print("time interval different from now to start", diffTimeIntervalNowAndStart)
        print("time interval from now till notification", notifTimeInterval)
        let notifDateTime = Date(timeIntervalSinceNow: notifTimeInterval)
        print("notification time", formatDateHHMM(date: notifDateTime))

        return notifTimeInterval
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
