//
//  Challenge.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import CoreData
import Foundation
import SwiftData

/// A model representing a savings challenge.
///
/// The `Challenge` class manages a list of savings (`Saving` objects) and
/// maintains a relationship with a `ChallengeConfiguration`, which defines
/// the parameters of the challenge.
@Model
class Challenge {
    /// The unique identifier for the challenge.
    @Attribute(.unique) var id: UUID

    /// A collection of savings associated with this challenge.
    @Relationship(deleteRule: .cascade) var savings = [Saving]()

    /// The configuration that defines the challenge rules.
    @Relationship(deleteRule: .cascade) var challengeConfiguration: ChallengeConfiguration

    /// Initializes a new challenge with a given configuration.
    ///
    /// - Parameter challengeConfiguration: The configuration defining the challenge settings.
    init(challengeConfiguration: ChallengeConfiguration) {
        id = UUID()
        self.challengeConfiguration = challengeConfiguration
        challengeConfiguration.generateSavings(challenge: self)
    }

    /// Adds a new saving entry to the challenge.
    ///
    /// - Parameter saving: The `Saving` instance to be added.
    func addSaving(saving: Saving) {
        savings.append(saving)
    }

    /// Removes a specific saving entry from the challenge.
    ///
    /// - Parameter saving: The `Saving` instance to be removed.
    func removeSaving(saving: Saving) {
        savings.removeAll(where: { $0.id == saving.id })
    }

    /// Updates the challenge configuration and regenerates the savings.
    ///
    /// - Parameter challengeConfiguration: The new challenge configuration.
    func updateConfiguration(challengeConfiguration: ChallengeConfiguration) {
        self.challengeConfiguration = challengeConfiguration
        challengeConfiguration.regenerateSavings(challenge: self)
    }

    /// Updates an existing saving entry with new values.
    ///
    /// - Parameter saving: The `Saving` instance containing updated values.
    func updateSaving(saving: Saving) {
        guard let index = savings.firstIndex(where: { $0.id == saving.id }) else { return }
        savings[index].amount = saving.amount
        savings[index].date = saving.date
        savings[index].done = saving.done
    }

    /// Calculates the total amount saved in this challenge.
    ///
    /// - Returns: The sum of all completed (`done == true`) savings amounts.
    func currentSavedAmount() -> Int {
        savings.filter(\.done).reduce(0) { $0 + $1.amount }
    }

    /// Calculates the progress of the challenge as a percentage.
    ///
    /// - Returns: The progress as a value between `0.0` and `1.0`.
    func progressPercentage() -> Double {
        Double(currentSavedAmount()) / Double(challengeConfiguration.amount)
    }

    /// Calculates the remaining amount needed to complete the challenge.
    ///
    /// - Returns: The remaining amount or `0` if the challenge is complete.
    func remainingAmount() -> Int {
        max(challengeConfiguration.amount - currentSavedAmount(), 0)
    }

    /// Counts the number of remaining savings entries.
    ///
    /// - Returns: The number of `Saving` entries that are not yet completed.
    func remainingSavings() -> Int {
        savings.filter { !$0.done }.count
    }

    /// Retrieves the next upcoming saving entry.
    ///
    /// - Parameter n: The position of the next saving (1-based index).
    /// - Returns: The `Saving` entry at the given position, or `nil` if unavailable.
    func getNextSaving(at n: Int) -> Saving? {
        let undoneSavings = savings.sorted { $0.date < $1.date }.filter { !$0.done }
        return undoneSavings.count >= n ? undoneSavings[n - 1] : nil
    }

    /// Retrieves the most recent saving entry.
    ///
    /// - Returns: The last `Saving` entry based on date.
    func getLastSaving() -> Saving {
        savings.sorted { $0.date < $1.date }.last!
    }
}
