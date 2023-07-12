//
//  WaterModel.swift
//  WaterTracker
//
//  Created by Илья Алексейчук on 04.07.2023.
//

import Foundation


//MARK: UserDefaults keys
enum KeysUserDefaults {
    static let settingsWater = "settingsWater"
    static let settingsTime = "settingsTime"
    static let settingsDate = "settingsDate"
}

//MARK: WaterModel
struct WaterModel: Codable {
    var currentAmount: Int
    var finalAmount: Int
}

//MARK: NotificationsTime
struct NotificationsTime: Codable {
    var notificationsEnabled: Bool
    var wakeUpTime: Date
    var goToBedTime: Date
    var timeInterval: Date
    var requestNames: [String]
}



class Settings {
    
    static var shared = Settings()
    
    //MARK: Declaring default values
    private let defaultWaterSettings = WaterModel(currentAmount: 0, finalAmount: 2000)
    lazy private var defaultTimeSettings = NotificationsTime(notificationsEnabled: false, wakeUpTime: formateDate(time: "10:00"),
                                                        goToBedTime: formateDate(time: "22:00"),
                                                             timeInterval: formateDate(time: "1:00"), requestNames: [])
    
    
    //MARK: Storing and retrieving data
    var currentWaterSettings: WaterModel {
        get {
            if let data = UserDefaults.standard.object(forKey: KeysUserDefaults.settingsWater) as? Data {
                return try! PropertyListDecoder().decode(WaterModel.self, from: data)
            } else {
                if let data = try? PropertyListEncoder().encode(defaultWaterSettings) {
                    UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.settingsWater)
                }
                return defaultWaterSettings
            }
            
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.settingsWater)
            }
        }
    }
    
    var currentTimeSettings: NotificationsTime {
        get {
            if let data = UserDefaults.standard.object(forKey: KeysUserDefaults.settingsTime) as? Data {
                return try! PropertyListDecoder().decode(NotificationsTime.self, from: data)
            } else {
                if let data = try? PropertyListEncoder().encode(defaultTimeSettings) {
                    UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.settingsTime)
                }
                return defaultTimeSettings
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.settingsTime)
            }
        }
    }
    
    var currentDateOnScreen: String {
        get {
            if let data = UserDefaults.standard.object(forKey: KeysUserDefaults.settingsDate) as? Data {
                return try! PropertyListDecoder().decode(String.self, from: data)
            } else {
                let settingsDate = Date().description.components(separatedBy: " ").first
                let settingsDay = (settingsDate?.components(separatedBy: "-").last)!
                
                if let data = try? PropertyListEncoder().encode(settingsDay) {
                    UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.settingsDate)
                }
                return settingsDay
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                UserDefaults.standard.setValue(data, forKey: KeysUserDefaults.settingsDate)
            }
        }
    }
    
    //MARK: Reset settings
    func resetSettings() {
        currentWaterSettings.finalAmount = defaultWaterSettings.finalAmount
        
        currentTimeSettings.wakeUpTime = defaultTimeSettings.wakeUpTime
        currentTimeSettings.goToBedTime = defaultTimeSettings.goToBedTime
        currentTimeSettings.timeInterval = defaultTimeSettings.timeInterval
        
    }
    
    //MARK: Formating date to save in default value
    private func formateDate(time: String) -> Date {
        let settingsDateFotmatter = DateFormatter()
        settingsDateFotmatter.timeZone = .gmt
        settingsDateFotmatter.dateFormat = "HH:mm"
        
        return settingsDateFotmatter.date(from: time)!
    }
    
}
