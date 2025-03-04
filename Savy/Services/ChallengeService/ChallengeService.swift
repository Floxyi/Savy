//
//  ChallengeService.swift
//  Savy
//
//  Created by Nadine Schatz on 11.10.24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class ChallengeService: ObservableObject {
    @Relationship(deleteRule: .cascade) var challenges = [Challenge]()

    /// Initializes a new `ChallengeService` instance.
    ///
    /// This initializer is used to create an instance of `ChallengeService`, which manages challenges in the app.
    init() {}

    /// Retrieves all challenges in the service.
    ///
    /// This method returns an array of all `Challenge` objects currently managed by the service.
    /// - Returns: An array of `Challenge` objects.
    func getAllChallenges() -> [Challenge] {
        challenges
    }

    /// Retrieves a challenge by its unique identifier.
    ///
    /// This method searches for and returns the `Challenge` object that matches the provided ID.
    /// - Parameter id: The unique identifier of the challenge to retrieve.
    /// - Returns: The `Challenge` object with the specified ID, or `nil` if not found.
    func getChallengeById(id: UUID) -> Challenge? {
        challenges.first { $0.id == id }
    }

    /// Adds a new challenge to the service.
    ///
    /// This method creates a new `Challenge` object using the provided configuration and adds it to the `challenges` array. It also logs the start of the challenge and schedules a notification.
    /// - Parameters:
    ///   - challengeConfiguration: The configuration that defines the parameters of the challenge.
    ///   - statsService: The `StatsService` used to record the start of the challenge.
    func addChallenge(challengeConfiguration: ChallengeConfiguration, statsService: StatsService) {
        let challenge = Challenge(challengeConfiguration: challengeConfiguration)
        statsService.addChallengeStartedStatsEntry(challengeId: challenge.id)
        createNotification(challenge: challenge)
        challenges.append(challenge)
    }

    /// Removes a challenge by its unique identifier.
    ///
    /// This method cancels the notification associated with the challenge and removes the challenge from the service.
    /// - Parameter id: The unique identifier of the challenge to remove.
    /// - statsService: The `StatsService` used to record the start of the challenge.
    func removeChallenge(id: UUID, statsService: StatsService) {
        challenges.forEach { challenge in NotificationService.shared.cancelNotification(challengeId: challenge.id.uuidString) }
        statsService.addChallengeDeletedStatsEntry()
        challenges.removeAll(where: { $0.id == id })
    }

    /// Removes all challenges from the service.
    ///
    /// This method iterates through all challenges, cancels their notifications, and removes them from the `challenges` array.
    func removeAllChallenges() {
        challenges.forEach { challenge in removeChallenge(id: challenge.id, statsService: StatsService()) }
    }

    /// Updates the configuration of an existing challenge.
    ///
    /// This method updates the configuration of the challenge with the specified ID, cancels the current notification, and schedules a new one based on the updated configuration.
    /// - Parameters:
    ///   - id: The unique identifier of the challenge to update.
    ///   - challengeConfiguration: The new configuration to apply to the challenge.
    func updateChallenge(id: UUID, challengeConfiguration: ChallengeConfiguration) {
        let challenge = challenges.first(where: { $0.id == id })!
        NotificationService.shared.cancelNotification(challengeId: challenge.id.uuidString)
        challenge.updateConfiguration(challengeConfiguration: challengeConfiguration)
        createNotification(challenge: challenge)
    }

    /// Schedules a notification for a challenge.
    ///
    /// This method schedules a notification for the challenge, alerting the user that the next saving for the challenge is due today.
    /// - Parameter challenge: The challenge for which to schedule the notification.
    private func createNotification(challenge: Challenge) {
        NotificationService.shared.scheduleNotification(
            challengeId: challenge.id.uuidString,
            title: String(localized: "Time to save money!"),
            body: String(localized: "The next saving for your challenge '\(challenge.challengeConfiguration.name)' is due today."),
            timeInterval: 60 * 60
        )
    }

    /// Sorts the challenges by their next saving date.
    ///
    /// This method sorts the challenges based on the date of their next saving. If a challenge is completed, it is sorted later than ongoing challenges. In case of ties, challenges are sorted by the end date or the saving amount.
    /// - Returns: A sorted array of `Challenge` objects.
    func sortChallenges() -> [Challenge] {
        let calendar = Calendar.current

        let sortedChallenges = challenges.sorted { (challenge1: Challenge, challenge2: Challenge) -> Bool in
            let nextSaving1 = challenge1.getNextSaving(at: 1) ?? challenge1.getLastSaving()
            let nextSaving2 = challenge2.getNextSaving(at: 1) ?? challenge2.getLastSaving()

            let dateComponents1 = DateComponents(
                year: calendar.component(.year, from: nextSaving1.date),
                month: calendar.component(.month, from: nextSaving1.date),
                day: calendar.component(.day, from: nextSaving1.date)
            )
            let dateComponents2 = DateComponents(
                year: calendar.component(.year, from: nextSaving2.date),
                month: calendar.component(.month, from: nextSaving2.date),
                day: calendar.component(.day, from: nextSaving2.date)
            )

            let date1 = calendar.date(from: dateComponents1) ?? Date()
            let date2 = calendar.date(from: dateComponents2) ?? Date()

            let remainingSavings1 = challenge1.remainingSavings()
            let remainingSavings2 = challenge2.remainingSavings()

            if remainingSavings1 == 0, remainingSavings2 == 0 {
                return challenge1.challengeConfiguration.endDate < challenge2.challengeConfiguration.endDate
            }

            if remainingSavings1 == 0 {
                return false
            }
            if remainingSavings2 == 0 {
                return true
            }

            return date1 == date2 ? nextSaving1.amount < nextSaving2.amount : date1 < date2
        }

        return sortedChallenges
    }
}
