//
//  StatsService.swift
//  Savy
//
//  Created by Nadine Schatz on 11.10.24.
//

import Foundation
import SwiftData
import SwiftUI

@Model
class StatsService: ObservableObject {
    var entries: [StatsEntry] = []

    init() {}

    private func addStatsEntry(entry: StatsEntry) {
        entries.append(entry)
    }

    func deleteStatsEntry(savingId: UUID) {
        entries.removeAll(where: { $0.savingStats?.savingId == savingId })
        updateSavingAmountInDatabase()
    }

    func deleteStatsEntry(challengeId: UUID) {
        entries.removeAll(where: { $0.challengeStats?.challengeId == challengeId })
    }

    func deleteStatsEntry(challengeId: UUID, statsType: StatsType) {
        entries.removeAll(where: { $0.challengeStats?.challengeId == challengeId && $0.type == statsType })
    }

    func addMoneySavedStatsEntry(savingId: UUID, amount: Int, date: Date) {
        let savingStats = SavingStats(savingId: savingId, amount: amount, expectedDate: date)
        let entry = StatsEntry(type: .money_saved, date: Date(), savingStats: savingStats)
        addStatsEntry(entry: entry)
        updateSavingAmountInDatabase()
    }

    func addChallengeCompletedStatsEntry(challengeId: UUID) {
        let challengeStats = ChallengeStats(challengeId: challengeId)
        let entry = StatsEntry(type: StatsType.challenge_completed, date: Date(), challengeStats: challengeStats)
        addStatsEntry(entry: entry)
    }

    func isChallengeCompleted(challengeId: UUID) -> Bool {
        entries.filter { $0.type == StatsType.challenge_completed }.contains(where: { $0.challengeStats?.challengeId == challengeId })
    }

    func addChallengeStartedStatsEntry(challengeId: UUID) {
        let challengeStats = ChallengeStats(challengeId: challengeId)
        let entry = StatsEntry(type: StatsType.challenge_started, date: Date(), challengeStats: challengeStats)
        addStatsEntry(entry: entry)
    }

    func totalMoneySaved() -> Int {
        entries
            .filter {
                $0.type == .money_saved
            }
            .compactMap {
                $0.savingStats?.amount
            }
            .reduce(0, +)
    }

    func totalChallengesCompleted() -> Int {
        entries
            .filter {
                $0.type == StatsType.challenge_completed
            }
            .count
    }

    func totalChallengesStarted() -> Int {
        entries
            .filter {
                $0.type == StatsType.challenge_started
            }
            .count
    }

    func allTimePunctuality() -> Int? {
        let allSavings = entries.filter {
            $0.type == .money_saved
        }
        if allSavings.isEmpty {
            return nil
        }

        let punctualSavings = allSavings.filter {
            $0.date <= $0.savingStats!.expectedDate
        }
        if punctualSavings.isEmpty {
            return nil
        }
        return Int(Double(punctualSavings.count) / Double(allSavings.count) * 100.rounded())
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
        entries.filter { entry in
            Calendar.current.startOfDay(for: entry.date) >= Calendar.current.startOfDay(for: startDate) && Calendar.current.startOfDay(for: entry.date) <= Calendar.current.startOfDay(for: endDate) && entry.type == statsType
        }
    }

    func timeRangeMoneySaved(startDate: Date, endDate: Date) -> Int {
        timeRangeCalculation(startDate: startDate, endDate: endDate, statsType: .money_saved).reduce(0) {
            $0 + $1.savingStats!.amount
        }
    }

    func timeRangeSavingCount(startDate: Date, endDate: Date) -> Int {
        timeRangeCalculation(startDate: startDate, endDate: endDate, statsType: .money_saved).count
    }

    func timeRangeChallengesCompleted(startDate: Date, endDate: Date) -> Int {
        timeRangeCalculation(startDate: startDate, endDate: endDate, statsType: StatsType.challenge_completed).count
    }

    func timeRangeChallengesStarted(startDate: Date, endDate: Date) -> Int {
        timeRangeCalculation(startDate: startDate, endDate: endDate, statsType: StatsType.challenge_started).count
    }

    func timeRangePunctuality(startDate: Date, endDate: Date) -> Double? {
        let allSavings = timeRangeCalculation(startDate: startDate, endDate: endDate, statsType: .money_saved)
        if allSavings.isEmpty {
            return nil
        }

        let punctualSavings = allSavings.filter {
            $0.date <= $0.savingStats!.expectedDate
        }
        return Double(punctualSavings.count) / Double(allSavings.count)
    }

    func averageSavedTimeRange(startDate: Date, endDate: Date) -> Double {
        let totalAmount = timeRangeMoneySaved(startDate: startDate, endDate: endDate)
        let numberOfDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        let allSaving = entries.filter { $0.type == .money_saved }

        if Calendar.current.isDate(startDate, inSameDayAs: endDate) {
            let savingsForDate = allSaving
                .filter {
                    Calendar.current.isDate($0.date, inSameDayAs: startDate)
                }
                .compactMap {
                    $0.savingStats?.amount
                }
                .reduce(0, +)
            return Double(savingsForDate)
        }

        if numberOfDays == 0, !allSaving.isEmpty {
            return Double(totalMoneySaved())
        }

        return numberOfDays > 0 ? Double(totalAmount) / Double(numberOfDays) : 0.0
    }

    func updateSavingAmountInDatabase() {
        Task {
            guard let profileId = AuthService.shared.profile?.id else { return }
            do {
                try await SavingsService.shared.updateSavingsAmount(amount: totalMoneySaved(), profileId: profileId)
            } catch {}
        }
    }

    func getCurrentStreak(challengeId: UUID, challengeService: ChallengeService) -> Int {
        let allSavings = entries.filter { $0.type == .money_saved && getChallengeIdFromSavingId(savingId: $0.savingStats!.savingId, challengeService: challengeService) == challengeId }
        if allSavings.isEmpty { return 0 }

        var streak = 0

        for entry in allSavings.reversed() {
            if let savingStats = entry.savingStats, entry.date <= savingStats.expectedDate {
                streak += 1
            } else {
                break
            }
        }

        return streak
    }

    private func getChallengeIdFromSavingId(savingId: UUID, challengeService: ChallengeService) -> UUID? {
        for challenge in challengeService.getAllChallenges() {
            if let _ = challenge.savings.first(where: { $0.id == savingId }) {
                return challenge.id
            }
        }
        return nil
    }
}
