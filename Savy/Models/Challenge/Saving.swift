//
//  Saving.swift
//  Savy
//
//  Created by Florian Winkler on 01.09.24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class Saving {
    @Attribute(.unique) var id: UUID
    @Relationship var challenge: Challenge
    var amount: Int
    var date: Date
    var done: Bool

    init(challenge: Challenge, amount: Int, date: Date) {
        id = UUID()
        self.challenge = challenge
        self.amount = amount
        self.date = Saving.getStandardDate(date: date)
        done = false
    }

    private static func getStandardDate(date: Date) -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(bySettingHour: 12, minute: 0, second: 0, of: calendar.date(from: components)!)!
    }

    func toggleDone(statsService: StatsService) {
        done.toggle()
        done ? markCompleted(statsService: statsService) : markNotCompleted(statsService: statsService)
    }

    private func markCompleted(statsService: StatsService) {
        statsService.addMoneySavedStatsEntry(savingId: id, amount: amount, date: date)
        if challenge.remainingAmount() == 0 {
            statsService.addChallengeCompletedStatsEntry(challengeId: challenge.id)
        }

        NotificationService.shared.cancelNotification(challengeId: challenge.id.uuidString)

        let nextSaving = challenge.getNextSaving(at: 1)
        if let nextSavingDate = nextSaving?.date {
            NotificationService.shared.scheduleNotification(
                challengeId: challenge.id.uuidString,
                title: String(localized: "Time to save money!"),
                body: String(localized: "The next saving for your challenge '\(challenge.challengeConfiguration.name)' is due today."),
                timeInterval: nextSavingDate.timeIntervalSinceNow
            )
        }
    }

    private func markNotCompleted(statsService: StatsService) {
        statsService.deleteStatsEntry(savingId: id)
        if statsService.isChallengeCompleted(challengeId: challenge.id) {
            statsService.deleteStatsEntry(challengeId: challenge.id, statsType: StatsType.challenge_completed)
        }

        NotificationService.shared.cancelNotification(challengeId: challenge.id.uuidString)

        NotificationService.shared.scheduleNotification(
            challengeId: challenge.id.uuidString,
            title: String(localized: "Time to save money!"),
            body: String(localized: "The next saving for your challenge '\(challenge.challengeConfiguration.name)' is due today."),
            timeInterval: date.timeIntervalSinceNow
        )
    }
}
