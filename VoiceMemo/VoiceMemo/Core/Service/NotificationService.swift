//
//  NotificationService.swift
//  VoiceMemo
//
//  Created by 이재훈 on 2024/01/09.
//

import UserNotifications
import UIKit

struct NotificationService {
    func sendNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            if granted {
                let content = UNMutableNotificationContent()
                content.title = "타이머 종료"
                content.body = "설정한 타이머가 종료되었습니다."
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
                let request = UNNotificationRequest(
                    identifier: UUID().uuidString,
                    content: content,
                    trigger: trigger
                )
                
                UNUserNotificationCenter.current().add(request)
            }
            else {
                let settingURLString = UIApplication.openNotificationSettingsURLString
                let settingURL = URL(string: settingURLString)
                if let url = settingURL {
                    DispatchQueue.main.async {
                        UIApplication.shared.open(url)
                    }
                }
            }
        }
    }
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}
