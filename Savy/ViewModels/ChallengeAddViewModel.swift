//
//  ChallengeAddViewModel.swift
//  Savy
//
//  Created by Florian Winkler on 08.02.25.
//

import SwiftData
import SwiftUI

class ChallengeAddViewModel: ObservableObject {
    @Published var icon: String?
    @Published var name: String = ""
    @Published var amount: Int?
    @Published var strategy: SavingStrategy = .Weekly
    @Published var calculation: SavingCalculation = .Date
    @Published var cycleAmount: Int?
    @Published var endDate: Date
    @Published var isDatePickerVisible = false
    @Published var isIconPickerVisible = false

    init() {
        endDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) ?? Date()
    }

    func updateEndDate() {
        let timespan = strategy == .Weekly ? Calendar.Component.weekOfYear : Calendar.Component.month
        let newEndDate = Calendar.current.date(byAdding: timespan, value: 1, to: Date()) ?? Date()
        endDate = newEndDate > endDate ? newEndDate : endDate
    }

    func isValid() -> Bool {
        icon != nil && !name.isEmpty && amount != nil && (calculation == .Amount ? cycleAmount != nil : true)
    }

    func getChallengeConfiguration() -> ChallengeConfiguration {
        ChallengeConfiguration(
            icon: icon ?? "square.dashed",
            name: name,
            amount: amount ?? 0,
            endDate: endDate,
            strategy: strategy,
            calculation: calculation,
            cycleAmount: cycleAmount
        )
    }

    func addChallenge() {
        let challengeConfiguration = getChallengeConfiguration()
        ChallengeManager.shared.addChallenge(challengeConfiguration: challengeConfiguration)
    }
}
