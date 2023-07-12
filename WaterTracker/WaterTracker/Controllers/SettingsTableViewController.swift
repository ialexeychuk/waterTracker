//
//  SettingsTableViewController.swift
//  WaterTracker
//
//  Created by Илья Алексейчук on 06.07.2023.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    let settings = Settings.shared
    let notifications = Notifications()
    
    var timeChanged = false
    
    @IBOutlet weak var notificationsEnableSwitch: UISwitch!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var timeInterval: UIDatePicker!
    @IBOutlet weak var goToBedTime: UIDatePicker!
    @IBOutlet weak var wakeUptime: UIDatePicker!
    @IBOutlet weak var volumeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        volumeTextField.keyboardType = .numberPad
        volumeTextField.placeholder = String(settings.currentWaterSettings.finalAmount)
        
        let theTap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        self.tableView.addGestureRecognizer(theTap)
        
        setupDate()
        
        doneButton.isEnabled = false
        notificationsEnableSwitch.isOn = settings.currentTimeSettings.notificationsEnabled
        
        
    }
    
    
    
    
    @objc func scrollViewTapped(recognizer: UIGestureRecognizer) {
        self.tableView.endEditing(true)
    }
    
    
    @IBAction func donePressed(_ sender: UIBarButtonItem) {
        if timeChanged {
            notifications.changeNotificationsSchedule()
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func wakeUpTimeChanged(_ sender: UIDatePicker) {
        
        settings.currentTimeSettings.wakeUpTime = sender.date
        
        goToBedTime.minimumDate = wakeUptime.date
        
        print(sender.date.timeToDouble())
        
        doneButton.isEnabled = true
        timeChanged = true
    }
    
    @IBAction func goToBedTimeChanged(_ sender: UIDatePicker) {
        settings.currentTimeSettings.goToBedTime = sender.date
        
        doneButton.isEnabled = true
        timeChanged = true
    }
    
    
    @IBAction func timeIntervalChanged(_ sender: UIDatePicker) {
        settings.currentTimeSettings.timeInterval = sender.date
        
        doneButton.isEnabled = true
        timeChanged = true
    }
    
    
    @IBAction func volumeChanged(_ sender: UITextField) {
        if let intValue = Int(sender.text ?? "") {
            settings.currentWaterSettings.finalAmount = intValue
        }
        
        doneButton.isEnabled = true
    }
    
    @IBAction func notificationEnableSwitched(_ sender: UISwitch) {
        settings.currentTimeSettings.notificationsEnabled = sender.isOn
        
        if sender.isOn {
            notifications.scheduleNotification()
        } else {
            notifications.removeNotifications()
        }
        
        doneButton.isEnabled = true
    }
    
    @IBAction func resetSettings(_ sender: UIButton) {
        settings.resetSettings()
        volumeTextField.placeholder = String(settings.currentWaterSettings.finalAmount)
        setupDate()
    }
    
    
    
    func setupDate() {
        
        wakeUptime.timeZone = .gmt
        goToBedTime.timeZone = .gmt
        timeInterval.timeZone = .gmt
        
        
        wakeUptime.date = settings.currentTimeSettings.wakeUpTime
        goToBedTime.date = settings.currentTimeSettings.goToBedTime
        timeInterval.date = settings.currentTimeSettings.timeInterval
    }
}
