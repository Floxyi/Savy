//
//  Saving.swift
//  Savy
//
//  Created by Florian Winkler on 01.09.24.
//

import Foundation
import SwiftData

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
        self.date = date
        done = false
    }

    func toggleDone() {
        done.toggle()
        done ? markCompleted() : markNotCompleted()
    }

    private func markCompleted() {
        StatsTracker.shared.addMoneySavedStatsEntry(savingId: id, amount: amount, date: date)
        if challenge.remainingAmount() == 0 {
            StatsTracker.shared.addChallengeCompletedStatsEntry(challengeId: challenge.id)
        }
    }

    private func markNotCompleted() {
        StatsTracker.shared.deleteStatsEntry(savingId: id)
        if StatsTracker.shared.isChallengeCompleted(challengeId: challenge.id) {
            StatsTracker.shared.deleteStatsEntry(challengeId: challenge.id, statsType: StatsType.challenged_completed)
        }
    }
}
