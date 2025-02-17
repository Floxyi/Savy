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

    init() {}

    func getAllChallenges() -> [Challenge] {
        challenges
    }

    func getChallengeById(id: UUID) -> Challenge? {
        challenges.first { $0.id == id }
    }

    func addChallenge(challengeConfiguration: ChallengeConfiguration, statsService: StatsService) {
        let challenge = Challenge(challengeConfiguration: challengeConfiguration)
        statsService.addChallengeStartedStatsEntry(challengeId: challenge.id)
        createNotification(challenge: challenge)
        challenges.append(challenge)
    }

    func removeChallenge(id: UUID) {
        challenges.forEach { challenge in NotificationService.shared.cancelNotification(challengeId: challenge.id.uuidString) }
        challenges.removeAll(where: { $0.id == id })
    }

    func removeAllChallenges() {
        challenges.forEach { challenge in removeChallenge(id: challenge.id) }
    }

    func updateChallenge(id: UUID, challengeConfiguration: ChallengeConfiguration) {
        let challenge = challenges.first(where: { $0.id == id })!
        NotificationService.shared.cancelNotification(challengeId: challenge.id.uuidString)
        challenge.updateConfiguration(challengeConfiguration: challengeConfiguration)
        createNotification(challenge: challenge)
    }

    private func createNotification(challenge: Challenge) {
        NotificationService.shared.scheduleNotification(
            challengeId: challenge.id.uuidString,
            title: String(localized: "Time to save money!"),
            body: String(localized: "The next saving for your challenge '\(challenge.challengeConfiguration.name)' is due today."),
            timeInterval: 60 * 60
        )
    }

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
