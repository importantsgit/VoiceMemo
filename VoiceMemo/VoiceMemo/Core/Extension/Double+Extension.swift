//
//  Double+Extension.swift
//  VoiceMemo
//
//  Created by 이재훈 on 2023/12/21.
//

import Foundation

extension Double {
    // 03:05
    var formattedTimeInterval: String {
        let totalSeconds = Int(self)
        let seconds = totalSeconds % 60
        let minutes = (totalSeconds / 60) % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
