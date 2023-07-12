//
//  DateExtension.swift
//  WaterTracker
//
//  Created by Илья Алексейчук on 08.07.2023.
//

import Foundation

extension Date {
    func timeToDouble() -> Double {
        let stringArray = self.description.components(separatedBy: " ")
        let stringTime = stringArray[1]
        let numberArray = stringTime.components(separatedBy: ":")
        let minutes = numberArray[1] == "00" ? 0.0 : 0.5
        let hours = Double(numberArray.first!)!
        
        return hours + minutes
    }
}
