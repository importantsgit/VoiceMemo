//
//  HomeViewModel.swift
//  VoiceMemo
//
//  Created by 이재훈 on 2024/01/09.
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var selectedTab: Tab
    @Published var todosCount: Int
    @Published var memosCount: Int
    @Published var voiceRecoderCount: Int
    
    init(
        selectedTab: Tab = .voiceRecoder,
        todosCount: Int = 0,
        memosCount: Int = 0,
        voiceRecoderCount: Int = 0
    ) {
        self.selectedTab = selectedTab
        self.todosCount = todosCount
        self.memosCount = memosCount
        self.voiceRecoderCount = voiceRecoderCount
    }
}

extension HomeViewModel {
    func setTodosCount(_ count: Int) {
        todosCount = count
    }
    
    func setMemoCount(_ count: Int) {
        memosCount = count
    }
    
    func setVoiceRecoderCount(_ count: Int) {
        voiceRecoderCount = count
    }
    
    func changeSelectedTab(_ tab: Tab) {
        selectedTab = tab
    }
}
