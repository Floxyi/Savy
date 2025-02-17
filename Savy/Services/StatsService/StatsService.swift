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

    /// Adds a `StatsEntry` to the `entries` array.
    ///
    /// This private method adds a given `StatsEntry` to the internal `entries` list. It is used internally to manage stats entries.
    /// - Parameter entry: The `StatsEntry` to add to the list.
    private func addStatsEntry(entry: StatsEntry) {
        entries.append(entry)
    }

    /// Deletes a `StatsEntry` associated with a specific saving ID.
    ///
    /// This method removes any entries linked to the provided saving ID and updates the saving amount in the database.
    /// - Parameter savingId: The `UUID` of the saving entry to delete.
    func deleteStatsEntry(savingId: UUID) {
        entries.removeAll(where: { $0.savingStats?.savingId == savingId })
        updateSavingAmountInDatabase()
    }

    /// Deletes a `StatsEntry` associated with a specific challenge ID.
    ///
    /// This method removes any entries linked to the provided challenge ID.
    /// - Parameter challengeId: The `UUID` of the challenge entry to delete.
    func deleteStatsEntry(challengeId: UUID) {
        entries.removeAll(where: { $0.challengeStats?.challengeId == challengeId })
    }

    /// Deletes a `StatsEntry` for a specific challenge ID and stats type.
    ///
    /// This method removes entries that match the given challenge ID and stats type.
    /// - Parameters:
    ///   - challengeId: The `UUID` of the challenge entry to delete.
    ///   - statsType: The type of stats entry to delete.
    func deleteStatsEntry(challengeId: UUID, statsType: StatsType) {
        entries.removeAll(where: { $0.challengeStats?.challengeId == challengeId && $0.type == statsType })
    }

    /// Adds a `StatsEntry` for money saved, associated with a specific saving ID.
    ///
    /// This method creates a new `StatsEntry` with the type `.money_saved` and adds it to the `entries` array. It also updates the saving amount in the database.
    /// - Parameters:
    ///   - savingId: The `UUID` of the saving entry to associate with.
    ///   - amount: The amount of money saved.
    ///   - date: The date of the saving.
    func addMoneySavedStatsEntry(savingId: UUID, amount: Int, date: Date) {
        let savingStats = SavingStats(savingId: savingId, amount: amount, expectedDate: date)
        let entry = StatsEntry(type: .money_saved, date: Date(), savingStats: savingStats)
        addStatsEntry(entry: entry)
        updateSavingAmountInDatabase()
    }

    /// Adds a `StatsEntry` for a completed challenge.
    ///
    /// This method creates a new `StatsEntry` with the type `.challenge_completed` and adds it to the `entries` array.
    /// - Parameter challengeId: The `UUID` of the completed challenge.
    func addChallengeCompletedStatsEntry(challengeId: UUID) {
        let challengeStats = ChallengeStats(challengeId: challengeId)
        let entry = StatsEntry(type: StatsType.challenge_completed, date: Date(), challengeStats: challengeStats)
        addStatsEntry(entry: entry)
    }

    /// Checks if a challenge has been completed by its ID.
    ///
    /// This method returns `true` if there is a record of the challenge with the type `.challenge_completed` in the `entries` array.
    /// - Parameter challengeId: The `UUID` of the challenge to check.
    /// - Returns: A `Bool` indicating whether the challenge has been completed.
    func isChallengeCompleted(challengeId: UUID) -> Bool {
        entries.filter { $0.type == StatsType.challenge_completed }.contains(where: { $0.challengeStats?.challengeId == challengeId })
    }

    /// Adds a `StatsEntry` for a challenge started.
    ///
    /// This method creates a new `StatsEntry` with the type `.challenge_started` and adds it to the `entries` array.
    /// - Parameter challengeId: The `UUID` of the challenge that was started.
    func addChallengeStartedStatsEntry(challengeId: UUID) {
        let challengeStats = ChallengeStats(challengeId: challengeId)
        let entry = StatsEntry(type: StatsType.challenge_started, date: Date(), challengeStats: challengeStats)
        addStatsEntry(entry: entry)
    }

    /// Calculates the total money saved.
    ///
    /// This method calculates the total amount of money saved by summing the amounts from all entries of type `.money_saved`.
    /// - Returns: The total amount of money saved as an `Int`.
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

    /// Calculates the total number of challenges completed.
    ///
    /// This method counts the number of entries of type `.challenge_completed`.
    /// - Returns: The total number of challenges completed.
    func totalChallengesCompleted() -> Int {
        entries
            .filter {
                $0.type == StatsType.challenge_completed
            }
            .count
    }

    /// Calculates the total number of challenges started.
    ///
    /// This method counts the number of entries of type `.challenge_started`.
    /// - Returns: The total number of challenges started.
    func totalChallengesStarted() -> Int {
        entries
            .filter {
                $0.type == StatsType.challenge_started
            }
            .count
    }

    /// Calculates the all-time punctuality as a percentage.
    ///
    /// This method calculates the percentage of punctual savings (entries where the saving date is on or before the expected date) out of all savings entries.
    /// - Returns: The punctuality percentage as an `Int`, or `nil` if there are no savings entries.
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

    /// Calculates the average amount saved per day since the first saving entry.
    ///
    /// This method calculates the average amount of money saved per day since the first saving entry.
    /// - Returns: The average saved amount per day as a `Double`.
    func averageSavedSinceFirstSavingEntry() -> Double {
        guard let startDate = entries.first(where: { $0.type == .money_saved })?.date else {
            return 0.0
        }

        let totalAmount = timeRangeMoneySaved(startDate: startDate, endDate: Date())
        let numberOfDays = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0

        return numberOfDays > 0 ? Double(totalAmount) / Double(numberOfDays) : 0.0
    }

    /// Filters entries within a specific date range for a given stats type.
    ///
    /// This method filters `entries` within the specified date range and returns only those of the given `StatsType`.
    /// - Parameters:
    ///   - startDate: The starting date of the range.
    ///   - endDate: The ending date of the range.
    ///   - statsType: The type of stats entries to filter by.
    /// - Returns: A list of `StatsEntry` objects within the date range.
    func timeRangeCalculation(startDate: Date, endDate: Date, statsType: StatsType) -> [StatsEntry] {
        entries.filter { entry in
            Calendar.current.startOfDay(for: entry.date) >= Calendar.current.startOfDay(for: startDate) && Calendar.current.startOfDay(for: entry.date) <= Calendar.current.startOfDay(for: endDate) && entry.type == statsType
        }
    }

    /// Calculates the total money saved within a specific date range.
    ///
    /// This method calculates the total amount of money saved within a specified date range by summing the amounts of entries of type `.money_saved`.
    /// - Parameters:
    ///   - startDate: The starting date of the range.
    ///   - endDate: The ending date of the range.
    /// - Returns: The total amount of money saved within the date range.
    func timeRangeMoneySaved(startDate: Date, endDate: Date) -> Int {
        timeRangeCalculation(startDate: startDate, endDate: endDate, statsType: .money_saved).reduce(0) {
            $0 + $1.savingStats!.amount
        }
    }

    /// Calculates the total number of savings within a specific date range.
    ///
    /// This method counts the number of savings entries of type `.money_saved` within a specified date range.
    /// - Parameters:
    ///   - startDate: The starting date of the range.
    ///   - endDate: The ending date of the range.
    /// - Returns: The total number of savings entries within the date range.
    func timeRangeSavingCount(startDate: Date, endDate: Date) -> Int {
        timeRangeCalculation(startDate: startDate, endDate: endDate, statsType: .money_saved).count
    }

    /// Calculates the total number of challenges completed within a specific date range.
    ///
    /// This method counts the number of challenges completed (entries of type `.challenge_completed`) within a specific date range.
    /// - Parameters:
    ///   - startDate: The starting date of the range.
    ///   - endDate: The ending date of the range.
    /// - Returns: The total number of challenges completed within the date range.
    func timeRangeChallengesCompleted(startDate: Date, endDate: Date) -> Int {
        timeRangeCalculation(startDate: startDate, endDate: endDate, statsType: StatsType.challenge_completed).count
    }

    /// Calculates the total number of challenges started within a specific date range.
    ///
    /// This method counts the number of challenges started (entries of type `.challenge_started`) within a specific date range.
    /// - Parameters:
    ///   - startDate: The starting date of the range.
    ///   - endDate: The ending date of the range.
    /// - Returns: The total number of challenges started within the date range.
    func timeRangeChallengesStarted(startDate: Date, endDate: Date) -> Int {
        timeRangeCalculation(startDate: startDate, endDate: endDate, statsType: StatsType.challenge_started).count
    }

    /// Calculates the punctuality within a specific date range.
    ///
    /// This method calculates the punctuality as the ratio of punctual savings to all savings within a specified date range.
    /// - Parameters:
    ///   - startDate: The starting date of the range.
    ///   - endDate: The ending date of the range.
    /// - Returns: The punctuality ratio as a `Double`, or `nil` if no savings entries exist within the range.
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

    /// Calculates the average saved amount per day within a specific date range.
    ///
    /// This method calculates the average amount saved per day within a specific date range. If the range spans only one day, it returns the total amount saved for that day.
    /// - Parameters:
    ///   - startDate: The starting date of the range.
    ///   - endDate: The ending date of the range.
    /// - Returns: The average saved amount per day within the date range.
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

    /// Updates the saving amount in the database for the current profile.
    ///
    /// This method fetches the current profile ID and updates the total money saved in the database by calling the `updateSavingsAmount` method from `SavingsService`.
    func updateSavingAmountInDatabase() {
        Task {
            guard let profileId = AuthService.shared.profile?.id else { return }
            do {
                try await SavingsService.shared.updateSavingsAmount(amount: totalMoneySaved(), profileId: profileId)
            } catch {}
        }
    }

    /// Determines if a saving is late based on its due date.
    ///
    /// This method checks if the saving's date is earlier than today, indicating that the saving is late.
    /// - Parameter saving: The `Saving` object to check.
    /// - Returns: A `Bool` indicating whether the saving is late.
    func isSavingLate(saving: Saving) -> Bool {
        let calendar = Calendar.current
        let savingDay = calendar.startOfDay(for: saving.date)
        let today = calendar.startOfDay(for: Date())
        return savingDay < today
    }

    /// Calculates the current streak for a specific challenge.
    ///
    /// This method calculates the current streak for a challenge, counting consecutive punctual savings entries (on or before expected date) for the given challenge.
    /// - Parameters:
    ///   - challengeId: The `UUID` of the challenge.
    ///   - challengeService: The `ChallengeService` used to retrieve challenges.
    /// - Returns: The current streak as an `Int`.
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

    /// Retrieves the challenge ID associated with a given saving ID.
    ///
    /// This method iterates through all challenges to find the one linked to the given saving ID.
    /// - Parameters:
    ///   - savingId: The `UUID` of the saving.
    ///   - challengeService: The `ChallengeService` used to retrieve challenges.
    /// - Returns: The `UUID` of the associated challenge, or `nil` if no match is found.
    private func getChallengeIdFromSavingId(savingId: UUID, challengeService: ChallengeService) -> UUID? {
        for challenge in challengeService.getAllChallenges() {
            if let _ = challenge.savings.first(where: { $0.id == savingId }) {
                return challenge.id
            }
        }
        return nil
    }
}
