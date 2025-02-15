//
//  Challenge.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import CoreData
import Foundation
import SwiftData

@Model
class Challenge {
    @Attribute(.unique) var id: UUID
    @Relationship(deleteRule: .cascade) var savings = [Saving]()
    @Relationship(deleteRule: .cascade) var challengeConfiguration: ChallengeConfiguration

    init(challengeConfiguration: ChallengeConfiguration) {
        id = UUID()
        self.challengeConfiguration = challengeConfiguration
        challengeConfiguration.generateSavings(challenge: self)
    }

    func addSaving(saving: Saving) {
        savings.append(saving)
    }

    func removeSaving(saving: Saving) {
        savings.removeAll(where: { $0.id == saving.id })
    }

    func updateConfiguration(challengeConfiguration: ChallengeConfiguration) {
        self.challengeConfiguration = challengeConfiguration
        challengeConfiguration.regenerateSavings(challenge: self)
    }

    func updateSaving(saving: Saving) {
        guard let index = savings.firstIndex(where: { $0.id == saving.id }) else { return }
        savings[index].amount = saving.amount
        savings[index].date = saving.date
        savings[index].done = saving.done
    }

    func currentSavedAmount() -> Int {
        savings.filter(\.done).reduce(0) { $0 + $1.amount }
    }

    func progressPercentage() -> Double {
        Double(currentSavedAmount()) / Double(challengeConfiguration.amount)
    }

    func remainingAmount() -> Int {
        max(challengeConfiguration.amount - currentSavedAmount(), 0)
    }

    func remainingSavings() -> Int {
        savings.filter { !$0.done }.count
    }

    func getNextSaving(at n: Int) -> Saving? {
        let undoneSavings = savings.sorted { $0.date < $1.date }.filter { !$0.done }
        return undoneSavings.count >= n ? undoneSavings[n - 1] : nil
    }

    func getLastSaving() -> Saving {
        savings.sorted { $0.date < $1.date }.last!
    }
}
