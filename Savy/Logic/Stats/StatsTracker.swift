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
    
    private(set) var entries: [ StatsEntry] = []
    
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
    
    func totalChallengesCompleted() -> Int {
        return entries
            .filter { $0.type == .challenged_completed }
            .count
    }
    
    func totalChallengesStarted() -> Int {
        return entries
            .filter { $0.type == .challenged_started }
            .count
    }
    
    func allTimePunctuality() -> Double {
        let allSavings = entries.filter { $0.type == .money_saved }
        let punctualSavings = allSavings.filter { $0.date <= $0.savingStats!.expectedDate }
        return Double(punctualSavings.count) / Double(allSavings.count)
    }
    
    func averageSavedSinceFirstSavingEntry() -> Double {
        guard let startDate = entries.first(where: { $0.type == .money_saved })?.date else {
            return 0.0
        }
        
        let totalAmount = timeRangeMoneySaved(startDate: startDate, endDate: Date())
        let numberOfDays = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
        
        return numberOfDays > 0 ? Double(totalAmount) / Double(numberOfDays) : 0.0
    }


    func timeRangeCalculation(startDate: Date, endDate: Date, statsType: StatsType) -> [StatsEntry] {
        return entries.filter { entry in
            entry.date >= startDate && entry.date <= endDate && entry.type == statsType
        }
    }
    
    func timeRangeMoneySaved(startDate: Date, endDate: Date) -> Int {
        return timeRangeCalculation(startDate: startDate, endDate: endDate, statsType: .money_saved).reduce(0) { $0 + $1.savingStats!.amount }
    }
    
    func timeRangeChallengesCompleted(startDate: Date, endDate: Date) -> Int {
        return timeRangeCalculation(startDate: startDate, endDate: endDate, statsType: .challenged_completed).count
    }
    
    func timeRangeChallengesStarted(startDate: Date, endDate: Date) -> Int {
        return timeRangeCalculation(startDate: startDate, endDate: endDate, statsType: .challenged_started).count
    }
    
    func timeRangePunctuality(startDate: Date, endDate: Date) -> Double {
        let allSavings = timeRangeCalculation(startDate: startDate, endDate: endDate, statsType: .money_saved)
        let punctualSavings = allSavings.filter { $0.date <= $0.savingStats!.expectedDate }
        return Double(punctualSavings.count) / Double(allSavings.count)
    }
    
    func averageSavedTimeRange(startDate: Date, endDate: Date) -> Double {
        let totalAmount = timeRangeMoneySaved(startDate: startDate, endDate: endDate)
        
        let numberOfDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        
        return numberOfDays > 0 ? Double(totalAmount) / Double(numberOfDays) : 0.0
    }
}
