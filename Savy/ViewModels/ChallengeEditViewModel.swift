//
//  ChallengeEditViewModel.swift
//  Savy
//
//  Created by Florian Winkler on 08.02.25.
//

import SwiftData
import SwiftUI

class ChallengeEditViewModel: ObservableObject {
    @Published var icon: String?
    @Published var name: String = ""
    @Published var amount: Int?
    @Published var strategy: SavingStrategy = .Weekly
    @Published var calculation: SavingCalculation = .Date
    @Published var cycleAmount: Int?
    @Published var endDate: Date = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) ?? Date()

    @Published var isDatePickerVisible = false
    @Published var isIconPickerVisible = false

    var challenge: Challenge

    init(challenge: Challenge) {
        self.challenge = challenge
        loadChallengeData()
    }

    private func loadChallengeData() {
        icon = challenge.challengeConfiguration.icon
        name = challenge.challengeConfiguration.name
        amount = challenge.challengeConfiguration.amount
        endDate = challenge.challengeConfiguration.endDate
        strategy = challenge.challengeConfiguration.strategy
        calculation = challenge.challengeConfiguration.calculation
        cycleAmount = challenge.challengeConfiguration.cycleAmount
    }

    func updateEndDate() {
        let newEndDate = Calendar.current.date(
            byAdding: strategy == .Weekly ? .weekOfYear : .month,
            value: 1,
            to: Date()
        ) ?? Date()

        endDate = newEndDate > endDate ? newEndDate : endDate
    }

    func isValid() -> Bool {
        icon != nil && name != "" && amount != nil && (calculation == .Amount ? cycleAmount != nil : true)
    }

    func calculateCycleAmount() -> Int {
        challenge.challengeConfiguration.calculateCycleAmount(amount: amount ?? 0, startDate: challenge.challengeConfiguration.startDate)
    }

    func calculateEndDateByAmount() -> String {
        let calculatedDate = challenge.challengeConfiguration.calculateEndDateByAmount(challenge: challenge, startDate: challenge.challengeConfiguration.startDate)
        return calculatedDate.formatted(.dateTime.day().month().year())
    }
}
