//
//  Date+Extension.swift
//  VoiceMemo
//
//  Created by 이재훈 on 2023/11/24.
//

import Foundation

extension Date {
    var formattedTime: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a hh:mm"
        
        return formatter.string(from: self)
    }
    
    var formattedDay: String {
        let now = Date()
        let calender = Calendar.current
        
        let nowStartOfDay = calender.startOfDay(for: now)
        let dateStartOfDay = calender.startOfDay(for: self)
        let numDaysDifference = calender.dateComponents([.day], from: nowStartOfDay, to: dateStartOfDay).day!
        
        if numDaysDifference == 0 {
            return "오늘"
        }
        else {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "M월 d일 E요일"
            return formatter.string(from: self)
        }
    }
}
