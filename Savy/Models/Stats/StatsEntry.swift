//
//  StatsEntry.swift
//  Savy
//
//  Created by Nadine Schatz on 11.10.24.
//

import Foundation
import SwiftData

/// A model representing an entry in the statistics log for savings or challenges.
///
/// This class is used to track different types of statistics entries, either related to
/// a specific saving or a challenge, along with the date the entry was recorded.
///
/// - `type`: The type of statistics entry (either related to a saving or challenge).
/// - `date`: The date when the statistics entry was recorded, set to the start of the day.
/// - `savingStats`: Optional reference to the related saving statistics, if applicable.
/// - `challengeStats`: Optional reference to the related challenge statistics, if applicable.
@Model
class StatsEntry {
    /// The type of statistics entry, indicating whether it relates to a saving or a challenge.
    var type: StatsType

    /// The date the statistics entry was recorded, set to the start of the day.
    var date: Date

    /// Optional reference to the related saving statistics, if applicable.
    var savingStats: SavingStats?

    /// Optional reference to the related challenge statistics, if applicable.
    var challengeStats: ChallengeStats?

    /// Initializes a new instance of `StatsEntry` with the given details.
    ///
    /// - Parameters:
    ///   - type: The type of statistics entry (saving or challenge).
    ///   - date: The date when the statistics entry was recorded.
    ///   - savingStats: An optional reference to the related saving statistics.
    ///   - challengeStats: An optional reference to the related challenge statistics.
    init(type: StatsType, date: Date, savingStats: SavingStats? = nil, challengeStats: ChallengeStats? = nil) {
        self.type = type
        self.date = Calendar.current.startOfDay(for: date)
        self.savingStats = savingStats
        self.challengeStats = challengeStats
    }
}
