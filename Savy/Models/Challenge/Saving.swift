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
        self.date = date
        done = false
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
    }

    private func markNotCompleted(statsService: StatsService) {
        statsService.deleteStatsEntry(savingId: id)
        if statsService.isChallengeCompleted(challengeId: challenge.id) {
            statsService.deleteStatsEntry(challengeId: challenge.id, statsType: StatsType.challenge_completed)
        }
    }
}
