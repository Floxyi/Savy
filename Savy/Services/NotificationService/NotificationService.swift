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

    /// Initializes the `NotificationService`, setting the delegate and checking notification permission status.
    ///
    /// This initializer sets the `NotificationService` as the delegate for `UNUserNotificationCenter` and checks the current status of the notification permission.
    override private init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
        checkPermissionStatus()
    }

    /// Checks the current notification permission status and updates `notificationAllowed`.
    ///
    /// This method fetches the current notification settings and updates the `notificationAllowed` flag based on whether notifications are authorized.
    func checkPermissionStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.notificationAllowed = settings.authorizationStatus == .authorized
            }
        }
    }

    /// Requests permission from the user to send notifications.
    ///
    /// This method prompts the user for notification permissions with options for alerts, badges, and sounds. It does not handle the response.
    func requestStartPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }

    /// Requests notification permission from the user and handles different authorization status cases.
    ///
    /// This method checks the current notification permission status and either requests permission, shows an alert if permission is denied, or updates the `notificationAllowed` flag accordingly.
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

    /// Opens the app settings page where the user can change notification settings.
    ///
    /// This method opens the app's settings page in the iOS settings app, allowing the user to modify their notification preferences.
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url)
        }
    }

    /// Schedules a notification for a specific challenge.
    ///
    /// This method schedules a notification to remind the user about a challenge with a specific title, body, and time interval.
    /// - Parameters:
    ///   - challengeId: The unique identifier for the challenge associated with the notification.
    ///   - title: The title of the notification.
    ///   - body: The body content of the notification.
    ///   - timeInterval: The time interval after which the notification will be triggered.
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

    /// Cancels a scheduled notification for a specific challenge.
    ///
    /// This method removes a scheduled notification based on its unique challenge identifier.
    /// - Parameter challengeId: The unique identifier for the challenge whose notification needs to be canceled.
    func cancelNotification(challengeId: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [challengeId])
    }

    /// Handles the presentation of notifications while the app is in the foreground.
    ///
    /// This method defines how notifications are presented when the app is in the foreground. It ensures that the notification is shown as a banner, in the notification list, and plays a sound.
    /// - Parameters:
    ///   - center: The notification center that is handling the notification.
    ///   - notification: The notification that is being presented.
    ///   - completionHandler: A completion handler that should be called after handling the notification.
    func userNotificationCenter(_: UNUserNotificationCenter, willPresent _: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .list, .sound])
    }

    /// Handles the notification response when the user taps on a notification.
    ///
    /// This method handles the user's interaction with a notification. It retrieves the challenge identifier from the notification and updates the `tappedChallengeId` property.
    /// - Parameters:
    ///   - center: The notification center that is handling the response.
    ///   - response: The response to the notification.
    ///   - completionHandler: A completion handler that should be called after processing the response.
    func userNotificationCenter(_: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let challengeId = response.notification.request.content.userInfo["challengeId"] as? String {
            DispatchQueue.main.async {
                self.tappedChallengeId = challengeId
            }
        }
        completionHandler()
    }

    /// Observes the notification tap and triggers a callback when a challenge notification is tapped.
    ///
    /// This method allows external components to observe when a notification is tapped by subscribing to the `tappedChallengeId` publisher. When a tap occurs, the provided action is executed with the challenge ID.
    /// - Parameter action: The closure to be executed when a challenge notification is tapped, passing the challenge ID as a parameter.
    func observeNotificationTap(action: @escaping (String) -> Void) {
        cancellable = $tappedChallengeId.compactMap(\.self).sink { challengeId in
            action(challengeId)
        }
    }
}
