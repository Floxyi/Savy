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
    private(set) var accountUUID: UUID?

    init() { }

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

    func removeAllEntries() {
        entries.removeAll()
        updateSavingAmountInDatabase()
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

    func allTimePunctuality() -> Int? {
        let allSavings = entries.filter { $0.type == .money_saved }
        if allSavings.isEmpty {
            return nil
        }

        let punctualSavings = allSavings.filter { $0.date <= $0.savingStats!.expectedDate }
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
        return entries.filter { entry in
            Calendar.current.startOfDay(for: entry.date) >= Calendar.current.startOfDay(for: startDate) && Calendar.current.startOfDay(for: entry.date) <= Calendar.current.startOfDay(for: endDate) && entry.type == statsType
        }
    }

    func timeRangeMoneySaved(startDate: Date, endDate: Date) -> Int {
        return timeRangeCalculation(startDate: startDate, endDate: endDate, statsType: .money_saved).reduce(0) { $0 + $1.savingStats!.amount }
    }

    func timeRangeSavingCount(startDate: Date, endDate: Date) -> Int {
        return timeRangeCalculation(startDate: startDate, endDate: endDate, statsType: .money_saved).count
    }

    func timeRangeChallengesCompleted(startDate: Date, endDate: Date) -> Int {
        return timeRangeCalculation(startDate: startDate, endDate: endDate, statsType: .challenged_completed).count
    }

    func timeRangeChallengesStarted(startDate: Date, endDate: Date) -> Int {
        return timeRangeCalculation(startDate: startDate, endDate: endDate, statsType: .challenged_started).count
    }

    func timeRangePunctuality(startDate: Date, endDate: Date) -> Double? {
        let allSavings = timeRangeCalculation(startDate: startDate, endDate: endDate, statsType: .money_saved)
        if allSavings.isEmpty {
            return nil
        }

        let punctualSavings = allSavings.filter { $0.date <= $0.savingStats!.expectedDate }
        return Double(punctualSavings.count) / Double(allSavings.count)
    }

    func averageSavedTimeRange(startDate: Date, endDate: Date) -> Double {
        let totalAmount = timeRangeMoneySaved(startDate: startDate, endDate: endDate)
        let numberOfDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        let allSaving = StatsTracker.shared.entries.filter { $0.type == .money_saved }

        if Calendar.current.isDate(startDate, inSameDayAs: endDate) {
            let savingsForDate = allSaving
                .filter { Calendar.current.isDate($0.date, inSameDayAs: startDate) }
                .compactMap { $0.savingStats?.amount }
                .reduce(0, +)
            return Double(savingsForDate)
        }

        if numberOfDays == 0 && !allSaving.isEmpty {
            return Double(StatsTracker.shared.totalMoneySaved())
        }

        return numberOfDays > 0 ? Double(totalAmount) / Double(numberOfDays) : 0.0
    }

    func getSavingsAmountFromDatabase(id: UUID) async throws -> Int {
        let users: [Profile] = try await AuthManager.shared.client.from("profiles").select().execute().value
        let savings: [Savings] = try await AuthManager.shared.client.from("savings").select().execute().value
        let user = users.first { $0.id == id }
        let saving = savings.first { $0.profileId == user?.id }
        return saving?.amount ?? 0
    }

    func updateSavingAmountInDatabase() {
        Task {
            do {
                let profileId = AuthManager.shared.profile?.id
                let savings: [Savings] = try await AuthManager.shared.client.from("savings").select().execute().value
                var savingsEntry = savings.first { $0.profileId == profileId }
                if savingsEntry == nil {
                    return
                }
                savingsEntry?.amount = totalMoneySaved()
                try await AuthManager.shared.client.from("savings").update(savingsEntry).eq("profile_id", value: profileId).execute()
            } catch { print(error) }
        }
    }

    func setAccountUUID(uuid: UUID?, sameAccount: Bool = true) {
        let hasRegisteredBefore = accountUUID != nil
        self.accountUUID = uuid
        if hasRegisteredBefore && sameAccount {
            self.removeAllEntries()
            ChallengeManager.shared.removeAllChallenges()
        }
    }
}
