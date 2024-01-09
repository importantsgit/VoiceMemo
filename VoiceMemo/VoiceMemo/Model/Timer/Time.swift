//
//  Time.swift
//  VoiceMemo
//
//  Created by 이재훈 on 2024/01/04.
//

import Foundation

struct Time {
    var hours: Int
    var minutes: Int
    var seconds: Int
    
    var convertedSeconds: Int {
        return (hours * 3600) + (minutes  * 60) + seconds
    }
    
    static func fromSeconds(_ seconds: Int) -> Time {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = (seconds % 3600) % 60
        return Time(
            hours: hours,
            minutes: minutes,
            seconds: seconds
        )
    }
}
