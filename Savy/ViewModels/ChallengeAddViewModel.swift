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
    @Published var startDate: Date { didSet { updateEndDate() } }
    @Published var endDate: Date

    @Published var isStartDatePickerVisible = false
    @Published var isEndDatePickerVisible = false
    @Published var isIconPickerVisible = false

    init() {
        startDate = Date()
        endDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: Date()) ?? Date()
    }

    func updateEndDate() {
        let minEndDate = Calendar.current.date(byAdding: strategy.calendarComponent, value: strategy.increment, to: startDate) ?? startDate
        endDate = endDate.compare(minEndDate) == .orderedAscending ? minEndDate : endDate
    }

    func isValid() -> Bool {
        icon != nil && !name.isEmpty && amount != nil && (calculation == .Amount ? cycleAmount != nil : true)
    }

    func getChallengeConfiguration() -> ChallengeConfiguration {
        ChallengeConfiguration(
            icon: icon ?? "square.dashed",
            name: name,
            amount: amount ?? 0,
            startDate: startDate,
            endDate: endDate,
            strategy: strategy,
            calculation: calculation,
            cycleAmount: cycleAmount
        )
    }

    func addChallenge(challengeService: ChallengeService, statsService: StatsService) {
        let challengeConfiguration = getChallengeConfiguration()
        challengeService.addChallenge(challengeConfiguration: challengeConfiguration, statsService: statsService)
    }
}
