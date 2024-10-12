//
//  StatsTracker.swift
//  Savy
//
//  Created by Nadine Schatz on 11.10.24.
//

import Foundation
import SwiftData

@Model
class StatsTracker {
    static let shared = StatsTracker()
    
    private(set) var entries: [StatsEntry] = []
    
    init() { }
    
    private func addStatsEntry(entry: StatsEntry) {
        entries.append(entry)
    }
    
    func deleteStatsEntry(savingId: UUID) {
        entries.removeAll(where: { $0.savingStats?.savingId == savingId })
    }
    
    func deleteStatsEntry(challengeId: UUID) {
        entries.removeAll(where: { $0.challengeStats?.challengeId == challengeId })
    }
    
    func addMoneySavedStatsEntry(savingId: UUID, amount: Int, date: Date) {
        let savingStats = SavingStats(savingId: savingId, amount: amount, expectedDate: date)
        let entry = StatsEntry(type: .money_saved, date: Date(), savingStats: savingStats)
        addStatsEntry(entry: entry)
    }
    
    func addChallengeCompletedStatsEntry(challengeId: UUID) {
        let challengeStats = ChallengeStats(challengeId: challengeId)
        let entry = StatsEntry(type: .challenged_completed, date: Date(), challengeStats: challengeStats)
        addStatsEntry(entry: entry)
    }
    
    func addChallengeStartedStatsEntry(challengeId: UUID) {
        let challengeStats = ChallengeStats(challengeId: challengeId)
        let entry = StatsEntry(type: .challenged_started, date: Date(), challengeStats: challengeStats)
        addStatsEntry(entry: entry)
    }
    
    func totalMoneySaved() -> Int {
        return entries
            .filter { $0.type == .money_saved }
            .compactMap { $0.savingStats?.amount }
            .reduce(0, +)
    }
}
