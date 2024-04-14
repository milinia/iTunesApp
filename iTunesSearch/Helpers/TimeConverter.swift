//
//  TimeConverter.swift
//  iTunesSearch
//
//  Created by Evelina on 14.04.2024.
//

import Foundation

final class TimeConverter {
    static func convertToMin(millis: Int) -> String {
        let hours =  millis / 3600000
        let remainingMillis = millis % 3600000
        let min = remainingMillis / 60000
        let sec =  (remainingMillis % 60000) / 1000
        
        var durationString = ""
        if hours > 0 {
            durationString += "\(hours):"
        }
        if min < 10 && hours > 0 {
            durationString += "0"
        }
        durationString += "\(min):"
        if sec < 10 {
            durationString += "0"
        }
        durationString += "\(sec)"
        return durationString
    }
}
