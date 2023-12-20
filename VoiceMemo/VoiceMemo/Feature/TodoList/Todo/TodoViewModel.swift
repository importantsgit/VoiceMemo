//
//  TodoViewModel.swift
//  VoiceMemo
//
//  Created by 이재훈 on 2023/11/28.
//

import Foundation

class TodoViewModel: ObservableObject {
    @Published var title: String
    @Published var time: Date
    @Published var day: Date
    @Published var isDisplayCalender: Bool
    
    init(
        title: String = "",
        time: Date = Date(),
        day: Date = Date(),
        isDisplayCalender: Bool = false
    ) {
        self.title = title
        self.time = time
        self.day = day
        self.isDisplayCalender = isDisplayCalender
    }
}

extension TodoViewModel {
    func setDisplayCalender(_ isDisplay: Bool) {
        isDisplayCalender = isDisplay
    }
}
