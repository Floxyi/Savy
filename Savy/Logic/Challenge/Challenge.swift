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
    private(set) var id: UUID
    private(set) var challengeConfiguration: ChallengeConfiguration
    private(set) var savings: [Saving]

    init(challengeConfiguration: ChallengeConfiguration) {
        id = UUID()
        self.challengeConfiguration = challengeConfiguration
        savings = []
        challengeConfiguration.generateSavings(
            challenge: self, amount: challengeConfiguration.amount,
            startDate: challengeConfiguration.startDate
        )
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
        savings.first(where: { $0.id == saving.id })?.setAmount(
            amount: saving.amount)
    }

    func currentSavedAmount() -> Int {
        savings.filter(\.done)
            .reduce(0) {
                $0 + $1.amount
            }
    }

    func progressPercentage() -> Double {
        Double(currentSavedAmount()) / Double(challengeConfiguration.amount)
    }

    func remainingAmount() -> Int {
        max(challengeConfiguration.amount - currentSavedAmount(), 0)
    }

    func remainingSavings() -> Int {
        savings.filter {
            !$0.done
        }
        .count
    }

    func getNextSaving(at n: Int) -> Saving {
        let undoneSavings = savings.sorted {
            $0.date < $1.date
        }
        .filter {
            !$0.done
        }
        return undoneSavings.count >= n ? undoneSavings[n - 1] : savings.first!
    }
}
