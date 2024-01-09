//
//  ContentView.swift
//  VoiceMemo
//
//  Created by 이재훈 on 2023/11/22.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    var notificationDelegate = NotificationDelegate()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool
    {
        UNUserNotificationCenter.current().delegate = notificationDelegate
        return true
    }
}
