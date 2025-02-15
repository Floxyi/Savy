//
//  NotificationService.swift
//  Savy
//
//  Created by Florian Winkler on 15.02.25.
//

import Combine
import SwiftUI
import UserNotifications

class NotificationService: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationService()

    @Published var tappedChallengeId: String?
    private var cancellable: AnyCancellable?

    @Published var notificationAllowed = false
    @Published var showSettingsAlert = false

    override private init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        checkPermissionStatus()
    }

    func checkPermissionStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.notificationAllowed = settings.authorizationStatus == .authorized
            }
        }
    }

    func requestStartPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }

    func requestPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                        DispatchQueue.main.async {
                            self.notificationAllowed = granted
                            if !granted {
                                self.showSettingsAlert = true
                            }
                        }
                    }
                case .denied:
                    self.showSettingsAlert = true
                case .authorized, .provisional, .ephemeral:
                    self.notificationAllowed = true
                @unknown default:
                    break
                }
            }
        }
    }

    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    func scheduleNotification(challengeId: String, title: String, body: String, timeInterval: TimeInterval) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        content.userInfo = ["challengeId": challengeId]

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
        let request = UNNotificationRequest(identifier: challengeId, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { _ in }
    }

    func cancelNotification(challengeId: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [challengeId])
    }

    func userNotificationCenter(_: UNUserNotificationCenter, willPresent _: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }

    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let challengeId = response.notification.request.content.userInfo["challengeId"] as? String {
            DispatchQueue.main.async {
                self.tappedChallengeId = challengeId
            }
        }
        completionHandler()
    }

    func observeNotificationTap(action: @escaping (String) -> Void) {
        cancellable = $tappedChallengeId.compactMap(\.self).sink { challengeId in
            action(challengeId)
        }
    }
}
