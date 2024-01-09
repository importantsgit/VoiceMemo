//
//  VoiceMemoApp.swift
//  VoiceMemo
//
//  Created by 이재훈 on 2023/11/22.
//
// 앱 진입점
import SwiftUI

@main
struct VoiceMemoApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    // UIKIT, 시스템 이벤트 -> adapter로 통해 상호작용 가능
    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
    }
}
