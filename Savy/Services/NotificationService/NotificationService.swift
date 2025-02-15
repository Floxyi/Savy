//
//  NotificationService.swift
//  Savy
//
//  Created by Florian Winkler on 15.02.25.
//

import Combine
import UserNotifications

class NotificationService: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationService()

    @Published var tappedChallengeId: String?
    private var cancellable: AnyCancellable?

    override private init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
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
