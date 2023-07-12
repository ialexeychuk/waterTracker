//
//  Notifications.swift
//  WaterTracker
//
//  Created by Илья Алексейчук on 06.07.2023.
//

import Foundation
import UserNotifications
import UIKit

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    
    let notificationCenter = UNUserNotificationCenter.current()
    let settings = Settings.shared
    
    func requestAutorization() {
        
        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            guard granted else { return }
            
            self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        notificationCenter.getNotificationSettings { settings in
            print(settings)
        }
    }
    
    
    func scheduleNotification() {
        
        createRequests(fromTime: settings.currentTimeSettings.wakeUpTime.timeToDouble(),
                       toTime: settings.currentTimeSettings.goToBedTime.timeToDouble(),
                       repeatsEvery: settings.currentTimeSettings.timeInterval.timeToDouble())
        
        let defaultAddAction = UNNotificationAction(identifier: "Add 250 ml", title: "Add 250 ml")
        let addAction = UNNotificationAction(identifier: "Add another amount", title: "Add another amount", options: [.foreground])
        let cancelAction = UNNotificationAction(identifier: "Cancel", title: "Cancel", options: [.destructive])
        
        let category = UNNotificationCategory(identifier: "User Action", actions: [defaultAddAction, addAction, cancelAction], intentIdentifiers: [])
        
        notificationCenter.setNotificationCategories([category])
    }
    
    
    
    func createRequests(fromTime: Double, toTime: Double, repeatsEvery: Double) {
        
        //MARK: Creating array of times when notifications will be sent
        
        let count = Int((toTime - fromTime) / repeatsEvery)
        var dates = [DateComponents]()
        
        for i in 0...count {
            let currentVatue = fromTime + (repeatsEvery * Double(i))
            
            var date = DateComponents()
            date.timeZone = .current
            date.hour = Int(currentVatue)
            date.minute = currentVatue == Double(Int(currentVatue)) ? 0 : 30
            
            dates.append(date)
        }
        
        var dateTocheck = DateComponents()
        dateTocheck.timeZone = .current
        dateTocheck.hour =  Int(toTime)
        dateTocheck.minute = toTime == Double(Int(toTime)) ? 0 : 30
        
        if !dates.contains(dateTocheck) {
            dates.append(dateTocheck)
        }
        
        
        
        //MARK: Creating notification requests
        
        let content = UNMutableNotificationContent()
        
        content.title = "Time to drink some water"
        content.body = "Drag to fill yor water tracker"
        content.sound = .default
        content.categoryIdentifier = "User Action"
        
        
        for i in 0..<dates.count {
            
            let name = "Local Notification №\(i)"
            settings.currentTimeSettings.requestNames.append(name)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dates[i], repeats: true)
            let request = UNNotificationRequest(identifier: name, content: content, trigger: trigger)
            
            notificationCenter.add(request)
        }
        
    }
    
    
    func changeNotificationsSchedule() {
        
        removeNotifications()
        
        createRequests(fromTime: settings.currentTimeSettings.wakeUpTime.timeToDouble(),
                       toTime: settings.currentTimeSettings.goToBedTime.timeToDouble(),
                       repeatsEvery: settings.currentTimeSettings.timeInterval.timeToDouble())
        
    }
    
    func removeNotifications() {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: settings.currentTimeSettings.requestNames)
        settings.currentTimeSettings.requestNames.removeAll()
    }
    
    
    
    //MARK: Method for receiving notifications during the app is active
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .banner])
    }
    
    //MARK: Notification response processing
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        switch response.actionIdentifier {
        case "Add 250 ml":
            Settings.shared.currentWaterSettings.currentAmount += 250
            
        default:
            print("Unknown Action")
        }
        
        completionHandler()
    }
    
    
}





