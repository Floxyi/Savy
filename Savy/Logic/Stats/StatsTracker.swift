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
    
    func deleteStatsEntry(id: UUID) {
        entries.removeAll(where: { $0.savingStats?.savingId == id })
    }
    
    func addMoneySavedStatsEntry(id: UUID, amount: Int, date: Date) {
        let saving = SavingStats(savingId: id, amount: amount, expectedDate: date)
        let entry = StatsEntry(type: .money_saved, date: Date(),savingStats: saving)
        addStatsEntry(entry: entry)
    }
    
    func addChallengeCompletedStatsEntry() {
        let entry = StatsEntry(type: .challenged_completed, date: Date())
        addStatsEntry(entry: entry)
    }
    
    func addChallengeStartedStatsEntry() {
        let entry = StatsEntry(type: .challenged_started, date: Date())
        addStatsEntry(entry: entry)
    }
    
    func totalMoneySaved() -> Int {
        var total: Int = 0
        for entry in entries {
            if entry.type == .money_saved && entry.savingStats != nil {
                total += entry.savingStats!.amount
            }
        }
        return total
    }
}
